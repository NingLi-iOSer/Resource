//
//  ViewController.swift
//  BlueToothTest
//
//  Created by Ning Li on 2019/3/14.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    private lazy var manager = BLEManager.shared
    /// 串口蓝牙设备
    private weak var serialPortPeripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    /// 定时器 - 定时查询状态
    private var timer: Timer?
    private lazy var peripheralArray = [CBPeripheral]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        manager.delegate = self
    }
    
    /// 查询状态
    @IBAction func sendMessage() {
        if timer == nil {
            let data = settingQueryStateData()
            queryState(data: data)
            
//            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] (_) in
//            })
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 设置查询状态数据
    func settingQueryStateData() -> Data {
        let dataArray: [UInt8] = [0x55, 0xAA, 0x02, 0x00, 0x00, 0x01]
        let dataValue = Data(bytes: dataArray)
        return dataValue
    }
    
    private func queryState(data: Data) {
        guard let peripheral = serialPortPeripheral,
            let characteristic = characteristic
            else {
                return
        }
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}

// MARK: - BLEManagerDelegate
extension ViewController: BLEManagerDelegate {
    func bleManager(_ manager: BLEManager, didUpdate state: BLEState) {
        switch state {
        case .poweredOff:
            print("蓝牙未开启")
        default:
            break
        }
    }
    
    func bleManager(_ manager: BLEManager, didDiscover peripheral: CBPeripheral) {
        if !peripheralArray.contains(peripheral) {
            peripheralArray.append(peripheral)
            tableView.reloadData()
        }
    }
    
    func bleManager(_ manager: BLEManager, connect result: BLEConnectResult, error: Error?) {
        switch result {
        case .connect:
            print("连接成功")
        case .failure:
            print("连接失败 error: \(error!)")
        case .disconnect:
            print("失去连接 error: \(error!)")
        }
    }
    
    func bleManager(_ manager: BLEManager, writeCharacteristic: CBCharacteristic) {
        characteristic = writeCharacteristic
        queryState(data: settingQueryStateData())
    }
    
    func bleManager(_ manager: BLEManager, peripheral: CBPeripheral, receive data: Data) {
        let bytes = [UInt8](data)
        if bytes.count == 12 {
            let decimal = Double(bytes[4] % 16)
            let count = Int64(bytes[5]) * 256 * 256 + Int64(bytes[6]) * 256 + Int64(bytes[7])
            if (bytes[4] / 16) > 0 {
                unitLabel.text = "单位\n码"
                countLabel.text = (Double(count) / (pow(10, decimal))).roundTo(places: 0).ignoreDecimalZero
            } else {
                unitLabel.text = "单位\n米"
                countLabel.text = (Double(count) / (pow(10, decimal))).roundTo(places: 1).ignoreDecimalZero
            }
            speedLabel.text = "\(Int(bytes[8]) * 256 + Int(bytes[9]))"
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = peripheralArray[indexPath.row].name
        cell.detailTextLabel?.text = peripheralArray[indexPath.row].identifier.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripheralArray[indexPath.row]
        manager.connect(peripheral: peripheral)
    }
}

extension Double {
    /// 保留小数位
    ///
    /// - Parameter places: 小数位数
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// 忽略小数点后的0
    var ignoreDecimalZero: String {
        let desc = self.description as NSString
        let pointLocation = desc.range(of: ".").location
        if Int(desc.substring(from: pointLocation + 1)) == 0 { // 缸数小数点后为 0
            return desc.substring(with: NSRange(location: 0, length: pointLocation))
        } else {
            return desc as String
        }
    }
}
