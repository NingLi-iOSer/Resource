//
//  BLEManager.swift
//  TestBlueTooth
//
//  Created by Ning Li on 2019/3/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import CoreBluetooth

/// 蓝牙状态
///
/// - poweredOn: 已开启
/// - poweredOff: 未开启
enum BLEState {
    case poweredOn
    case poweredOff
}

/// 连接结果
///
/// - connect: 连接成功
/// - failure: 连接失败
/// - disconnect: 失去连接
enum BLEConnectResult {
    case connect
    case failure
    case disconnect
}

protocol BLEManagerDelegate: class {
    /// 更新蓝牙状态
    func bleManager(_ manager: BLEManager, didUpdate state: BLEState)
    
    /// 回调扫描到的设备
    func bleManager(_ manager: BLEManager, didDiscover peripheral: CBPeripheral)
    
    /// 回调连接结果
    func bleManager(_ manager: BLEManager, connect result: BLEConnectResult, error: Error?)
    
    /// 回调写特征, 读特征
    func bleManager(_ manager: BLEManager, writeCharacteristic: CBCharacteristic)
    
    /// 接收数据回调
    func bleManager(_ manager: BLEManager, peripheral: CBPeripheral, receive data: Data)
}

extension BLEManagerDelegate {
    func bleManager(_ manager: BLEManager, didUpdate state: BLEState) { }
    func bleManager(_ manager: BLEManager, didDiscover peripheral: CBPeripheral) { }
    func bleManager(_ manager: BLEManager, connect result: BLEConnectResult, error: Error?) { }
    func bleManager(_ manager: BLEManager, writeCharacteristic: CBCharacteristic) { }
    func bleManager(_ manager: BLEManager, peripheral: CBPeripheral, receive data: Data) { }
}

/// 蓝牙操作管理
class BLEManager: NSObject {
    
    internal weak var delegate: BLEManagerDelegate?
    
    static let shared: BLEManager = {
        let manager = BLEManager()
        manager.center = CBCentralManager(delegate: manager, queue: DispatchQueue.main)
        return manager
    }()
    
    private var center: CBCentralManager!
}

// MARK: - 公开方法
extension BLEManager {
    /// 连接设备
    ///
    /// - Parameter peripheral: 蓝牙设备
    public func connect(peripheral: CBPeripheral) {
        center.connect(peripheral, options: nil)
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEManager: CBCentralManagerDelegate {
    /// 更新蓝牙状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch center.state {
        case .poweredOn:
            // 扫描设备
            central.scanForPeripherals(withServices: nil, options: nil)
            delegate?.bleManager(self, didUpdate: .poweredOn)
        default:
            delegate?.bleManager(self, didUpdate: .poweredOff)
        }
    }
    
    /// 发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            delegate?.bleManager(self, didDiscover: peripheral)
        }
    }
    
    /// 连接设备成功回调
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.bleManager(self, connect: .connect, error: nil)
        
        peripheral.delegate = self
        // 发现服务
        peripheral.discoverServices(nil)
    }
    
    /// 连接失败回调
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bleManager(self, connect: .failure, error: error)
    }
    
    /// 失去连接回调
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.bleManager(self, connect: .disconnect, error: error)
    }
}

// MARK: - CBPeripheralDelegate
extension BLEManager: CBPeripheralDelegate {
    /// 发现服务结果回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        // 发现特征
        services.forEach { peripheral.discoverCharacteristics(nil, for: $0) }
    }
    
    /// 发现特征
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        characteristics.forEach { (ch) in
            if ch.properties.contains(CBCharacteristicProperties.writeWithoutResponse) ||
                ch.properties.contains(CBCharacteristicProperties.write) {
                delegate?.bleManager(self, writeCharacteristic: ch)
            }
            
            if ch.properties.contains(CBCharacteristicProperties.read) {
                peripheral.readValue(for: ch)
                peripheral.setNotifyValue(true, for: ch)
            }
        }
    }
    
    /// 接收数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            return
        }
        delegate?.bleManager(self, peripheral: peripheral, receive: data)
    }
}
