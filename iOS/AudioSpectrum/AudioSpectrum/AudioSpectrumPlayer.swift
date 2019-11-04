//
//  AudioSpectrumPlayer.swift
//  AudioSpectrum
//
//  Created by Ning Li on 2019/3/13.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import AVFoundation
import Accelerate

protocol AudioSpectrumPlayerDelegate: AnyObject {
    func player(_ player: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]])
}

class AudioSpectrumPlayer {
    
    weak var delegate: AudioSpectrumPlayerDelegate?
    
    private lazy var engine = AVAudioEngine()
    private lazy var player = AVAudioPlayerNode()
    
    private var fftSize: Int = 2048
    private lazy var fftSetup = vDSP_create_fftsetup(vDSP_Length(bitPattern: Int(log2(Double(fftSize)))), FFTRadix(bitPattern: UInt32(kFFTRadix2)))
    
    public var frequencyBands: Int = 80
    public var startFrequency: Float = 100
    public var endFrequency: Float = 18000
    
    private var spectrumBuffer = [[Float]]()
    private var spectrumSmooth: Float = 0.5 {
        didSet {
            spectrumSmooth = max(0.0, spectrumSmooth)
            spectrumSmooth = min(1.0, spectrumSmooth)
        }
    }
    
    private lazy var bands: [(lowerFrequency: Float, upperFrequency: Float)] = {
        var bands = [(lowerFrequency: Float, upperFrequency: Float)]()
        
        let n = log2(endFrequency / startFrequency) / Float(frequencyBands)
        var nextBand: (lowerFrequency: Float, upperFrequency: Float) = (startFrequency, 0)
        for i in 1...frequencyBands {
            let highFrequency = nextBand.lowerFrequency * pow(2, n)
            nextBand.upperFrequency = (i == frequencyBands) ? endFrequency : highFrequency
            bands.append(nextBand)
            nextBand.lowerFrequency = highFrequency
        }
        
        return bands
    }()
    
    init() {
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(fftSize), format: nil) { [unowned self] (buffer, when) in
            if !self.player.isPlaying {
                return
            }
            buffer.frameLength = AVAudioFrameCount(self.fftSize)
            let amplitudes = self.analyse(buffer)
            DispatchQueue.main.async {
                self.delegate?.player(self, didGenerateSpectrum: amplitudes)
            }
        }
        engine.prepare()
        try? engine.start()
    }
    
    deinit {
        vDSP_destroy_fftsetup(fftSetup)
    }
    
    func play(_ fileName: String) {
        guard let resourceURL = Bundle.main.url(forResource: fileName, withExtension: nil),
            let audioFile = try? AVAudioFile(forReading: resourceURL)
            else {
                return
        }
        player.stop()
        player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        player.play()
    }
    
    func stop() {
        player.stop()
    }
    
    func fft(_ buffer: AVAudioPCMBuffer) -> [[Float]] {
        var amplitudes = [[Float]]()
        
        guard let floatChannerData = buffer.floatChannelData else {
            return amplitudes
        }
        var channels: UnsafePointer<UnsafeMutablePointer<Float>> = floatChannerData
        let channerCount = Int(buffer.format.channelCount)
        let isInterleaved = buffer.format.isInterleaved
        
        if isInterleaved {
            let interleavedData = UnsafeBufferPointer(start: floatChannerData[0], count: fftSize * channerCount)
            var channelsTemp: [UnsafeMutablePointer<Float>] = []
            for i in 0..<channerCount {
                var channelData = stride(from: i, to: interleavedData.count, by: channerCount).map { interleavedData[$0] }
                channelsTemp.append(UnsafeMutablePointer(&channelData))
            }
            channels = UnsafePointer(channelsTemp)
        }
        
        for i in 0..<channerCount {
            let channel = channels[i]
            var window = [Float](repeating: 0, count: fftSize)
            vDSP_hann_window(&window, vDSP_Length(fftSize), Int32(vDSP_HANN_NORM))
            vDSP_vmul(channel, 1, window, 1, channel, 1, vDSP_Length(fftSize))
            
            var realp = [Float](repeating: 0, count: fftSize / 2)
            var imagp = [Float](repeating: 0, count: fftSize / 2)
            var fftInOut = DSPSplitComplex(realp: &realp, imagp: &imagp)
            channel.withMemoryRebound(to: DSPComplex.self, capacity: fftSize) { (typeConvertedTransferBuffer) -> Void in
                vDSP_ctoz(typeConvertedTransferBuffer, 2, &fftInOut, 1, vDSP_Length(fftSize / 2))
            }
            
            vDSP_fft_zrip(fftSetup!, &fftInOut, 1, vDSP_Length(round(log2(Double(fftSize)))), FFTDirection(FFT_FORWARD))
            
            fftInOut.imagp[0] = 0
            let fftNormalFactor = Float(1.0 / Float(fftSize))
            vDSP_vsmul(fftInOut.realp, 1, [fftNormalFactor], fftInOut.realp, 1, vDSP_Length(fftSize / 2))
            vDSP_vsmul(fftInOut.imagp, 1, [fftNormalFactor], fftInOut.imagp, 1, vDSP_Length(fftSize / 2))
            var channelAmplitudes = [Float](repeating: 0, count: fftSize / 2)
            vDSP_zvabs(&fftInOut, 1, &channelAmplitudes, 1, vDSP_Length(fftSize / 2))
            channelAmplitudes[0] = channelAmplitudes[0] / 2
            amplitudes.append(channelAmplitudes)
        }
        
        return amplitudes
    }
    
    private func findMaxAmplitude(for band: (lowerFrequency: Float, upperFrequency: Float), in amplitudes: [Float], with bandWidth: Float) -> Float {
        let startIndex = Int(round(band.lowerFrequency / bandWidth))
        let endIndex = min(Int(round(band.upperFrequency / bandWidth)), amplitudes.count - 1)
        return amplitudes[startIndex...endIndex].max()!
    }
    
    func analyse(_ buffer: AVAudioPCMBuffer) -> [[Float]] {
        let channelsAmplitudes = fft(buffer)
        let aWeights = createFrequencyWeights()
        if spectrumBuffer.count == 0 {
            for _ in 0..<channelsAmplitudes.count {
                spectrumBuffer.append(Array<Float>(repeating: 0, count: frequencyBands))
            }
        }
        for (index, amplitudes) in channelsAmplitudes.enumerated() {
            let weightdAmplitudes = amplitudes.enumerated().map { (index, element) in
                return element * aWeights[index]
            }
            var spectrum = bands.map({ (band) -> Float in
                return findMaxAmplitude(for: band, in: weightdAmplitudes, with: Float(buffer.format.sampleRate) / Float(fftSize)) * 5
            })
            spectrum = highlightWaveform(spectrum: spectrum)
            let zipped = zip(spectrumBuffer[index], spectrum)
            spectrumBuffer[index] = zipped.map { $0.0 * spectrumSmooth + $0.1 * (1 - spectrumSmooth) }
        }
        return spectrumBuffer
    }
    
    private func createFrequencyWeights() -> [Float] {
        let Δf = 44100.0 / Float(fftSize)
        let bins = fftSize / 2 //返回数组的大小
        var f = (0..<bins).map { Float($0) * Δf}
        f = f.map { $0 * $0 }
        
        let c1 = powf(12194.217, 2.0)
        let c2 = powf(20.598997, 2.0)
        let c3 = powf(107.65265, 2.0)
        let c4 = powf(737.86223, 2.0)
        
        let num = f.map { c1 * $0 * $0 }
        let den = f.map { ($0 + c2) * sqrtf(($0 + c3) * ($0 + c4)) * ($0 + c1) }
        let weights = num.enumerated().map { (index, ele) in
            return 1.2589 * ele / den[index]
        }
        return weights
    }
    
    private func highlightWaveform(spectrum: [Float]) -> [Float] {
        //1: 定义权重数组，数组中间的5表示自己的权重
        //   可以随意修改，个数需要奇数
        let weights: [Float] = [1, 2, 3, 5, 3, 2, 1]
        let totalWeights = Float(weights.reduce(0, +))
        let startIndex = weights.count / 2
        //2: 开头几个不参与计算
        var averagedSpectrum = Array(spectrum[0..<startIndex])
        for i in startIndex..<spectrum.count - startIndex {
            //3: zip作用: zip([a,b,c], [x,y,z]) -> [(a,x), (b,y), (c,z)]
            let zipped = zip(Array(spectrum[i - startIndex...i + startIndex]), weights)
            let averaged = zipped.map { $0.0 * $0.1 }.reduce(0, +) / totalWeights
            averagedSpectrum.append(averaged)
        }
        //4：末尾几个不参与计算
        averagedSpectrum.append(contentsOf: Array(spectrum.suffix(startIndex)))
        return averagedSpectrum
    }
}
