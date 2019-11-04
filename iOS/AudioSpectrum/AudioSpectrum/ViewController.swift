//
//  ViewController.swift
//  AudioSpectrum
//
//  Created by Ning Li on 2019/3/13.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var spectrumView: SpectrumView!
    
    private lazy var player = AudioSpectrumPlayer()
    
    private lazy var musicData = ["01.Halcyon - Runaway (Feat. Valentina Franco) (Heuse Remix).mp3",
                                  "03.Spektrum & Sara Skinner - Keep You.mp3",
                                  "02.Ellis - Clear My Head (Radio Edit) [NCS].mp3",
                                  "Jauve AUS-Jauve aus，7月30号放送 (Remix).mp3",
                                  "阿涵 - 过客.mp3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        player.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = musicData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = musicData[indexPath.row]
        player.play(name)
    }
}

// MARK: - AudioSpectrumPlayerDelegate
extension ViewController: AudioSpectrumPlayerDelegate {
    func player(_ player: AudioSpectrumPlayer, didGenerateSpectrum spectra: [[Float]]) {
        spectrumView.spectra = spectra
    }
}
