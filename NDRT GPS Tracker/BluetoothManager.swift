import CoreBluetooth

protocol BluetoothManagerDelegate: AnyObject {
    func didUpdateConnectionState(connected: Bool)
    func didDiscoverPeripheral(peripheral: CBPeripheral)
    func didReceiveValue(value: String)
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    weak var delegate: BluetoothManagerDelegate?

    var centralManager: CBCentralManager?
    var myPeripheral: CBPeripheral?
    var myCharacteristic: CBCharacteristic?

    let serviceUUID = CBUUID(string: "ab0828b1-198e-4351-b779-901fa0e0371e")
    let targetCharacteristicUUID = CBUUID(string: "4AC8A682-9736-4E5D-932B-E9B31405049C")
    let readCharacteristicUUID = CBUUID(string: "9db335aa-0c19-4a29-93c9-2dabeb1dd044")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func scanForPeripherals() {
        guard let central = centralManager, central.state == .poweredOn else {
            print("Bluetooth is not available.")
            return
        }
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func stopScan() {
        centralManager?.stopScan()
    }

    func connect(peripheral: CBPeripheral) {
        myPeripheral = peripheral
        myPeripheral?.delegate = self
        centralManager?.connect(peripheral, options: nil)
    }

    func disconnect() {
        if let peripheral = myPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }

    func sendText(text: String) {
        guard let peripheral = myPeripheral, let characteristic = myCharacteristic else {
            print("Peripheral or characteristic not found.")
            return
        }

        if let data = text.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth is switched off")
        case .poweredOn:
            print("Bluetooth is switched on")
            delegate?.didUpdateConnectionState(connected: false)
        case .unsupported:
            print("Bluetooth is not supported")
        default:
            print("Unknown state")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "Unknown")")
        myPeripheral = peripheral
        myPeripheral?.delegate = self
        delegate?.didDiscoverPeripheral(peripheral: peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        peripheral.discoverServices([serviceUUID])
        delegate?.didUpdateConnectionState(connected: true)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Failed to disconnect: \(error.localizedDescription)")
        } else {
            print("Disconnected from \(peripheral.name ?? "Unknown")")
        }
        delegate?.didUpdateConnectionState(connected: false)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            print("No services found.")
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else {
            print("No characteristics found in service \(service.uuid).")
            return
        }

        for characteristic in characteristics {
            if characteristic.uuid == targetCharacteristicUUID {
                myCharacteristic = characteristic
                print("Target characteristic for sending data found.")
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }

        if characteristic.uuid == readCharacteristicUUID {
            if let value = characteristic.value {
                let stringValue = String(data: value, encoding: .utf8) ?? "unknown"
                delegate?.didReceiveValue(value: stringValue)
            } else {
                print("No value received from characteristic \(characteristic.uuid)")
            }
        }
    }
}
