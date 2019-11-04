//
//  ViewController.swift
//  TestBlueTooth
//
//  Created by Ning Li on 2019/2/18.
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
    
    @IBOutlet weak var tableView: UITableView!
    private lazy var peripheralArray = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        manager.delegate = self
    }
    
    /// 查询状态
    @IBAction func sendMessage() {
        if timer == nil {
            let data = settingQueryStateData()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] (_) in
                self?.queryState(data: data)
            })
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
