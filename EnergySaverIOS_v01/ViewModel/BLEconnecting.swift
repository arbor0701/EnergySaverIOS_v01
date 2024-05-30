
import SwiftUI
import CoreBluetooth
import SwiftData

//
@Observable
class BLEconnecting: NSObject, CBPeripheralDelegate
{
    private var centralManager: CBCentralManager!
    private var peripherals:[CBPeripheral] = []
    private var blePeripheral:CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    var peripheralId:[String] = []
    var valueFromBLE:String? = "no value"
    var BLE_Service_uuid:CBUUID = CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")
    var BLE_Characteristic_uuid_Rx:CBUUID?
    var BLE_Characteristic_uuid_Tx:CBUUID?
    var bleConnectionStatus : String = "Disconnected"
    var bleConnectionStrength:Int = 0
    var deviceInfo:DeviceInfo?
    var sensorDataDecoded:DataModel = DataModel()


    override init()
    {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .global(qos: .userInteractive))
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        print("Discoveredd")
        peripherals.append(peripheral)
        peripheralId.append(peripheral.name ?? peripheral.identifier.uuidString)
        print(peripheral.name ?? "no name")
        print(peripheral.identifier.uuidString)
        print(RSSI)
        bleConnectionStrength = RSSI.intValue
        centralManager?.stopScan()
        blePeripheral = peripheral
        blePeripheral.delegate = self
        centralManager?.connect(blePeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        print("connected")
        self.bleConnectionStatus = "connected"
        blePeripheral.discoverServices([BLE_Service_uuid])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        print("Disconnected")
        self.bleConnectionStatus  = "disconnected"
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        print("*******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else {
            return
        }
        print("services discovered: \(services)")
        //We need to discover the all characteristic
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discoveredd Services: \(services)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?)
    {
        print("RSSI: \(RSSI)")
        self.bleConnectionStrength = RSSI.intValue
    }
    
    func peripheral(_ peripheral: CBPeripheral,didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("Found \(characteristics.count) characteristics.")
        
        for characteristic in characteristics {
            
            if characteristic.uuid.isEqual(self.BLE_Characteristic_uuid_Rx)  {
                
                rxCharacteristic = characteristic
                
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                
                print("RX Characteristic: \(rxCharacteristic.uuid)")
                print("RX Characteristic: \(String(describing: rxCharacteristic))" )
            }
            
            if characteristic.uuid.isEqual(self.BLE_Characteristic_uuid_Tx){
                
                txCharacteristic = characteristic
                
                print("TX Characteristic: \(txCharacteristic.uuid)")
                print("TX Characteristic: \(String(describing: txCharacteristic))" )
            }
        }
    }
 
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        var characteristicASCIIValue = NSString()
        
        
        guard characteristic == rxCharacteristic,
              
                let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }
        
        characteristicASCIIValue = ASCIIstring
        print("Value Recieved: \(characteristic)")
        print("Value Recieved: \((characteristicASCIIValue as String))")
        valueFromBLE = (characteristicASCIIValue as String)
        if valueFromBLE != nil
        {
            print("Value Reciedddved: \((valueFromBLE!))")
            sensorDataDecoded=jsonConverter(jsonDataFromSensor: valueFromBLE!)
            
            print("Value Recieddddved: \((sensorDataDecoded.SHT31_TEMP))")
            
        }
    }
    
    func writeValue(data: String) {
        guard blePeripheral != nil else { return }
        
        let dataToSend = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        guard txCharacteristic != nil else { return }
        blePeripheral.writeValue(dataToSend!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
}

extension BLEconnecting:CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
        case .poweredOff:
            print("Is Powered Off.")
            bleConnectionStatus = "Powered off"
        case .poweredOn:
            print("Is Powered On.")
        case .unsupported:
            print("Is Unsupported.")
            bleConnectionStatus = "Unsupported"
        case .unauthorized:
            print("Is Unauthorized.")
            bleConnectionStatus = "Unauthorized"
        case .unknown:
            print("Unknown")
            bleConnectionStatus = "Unknown"
        case .resetting:
            print("Resetting")
            
        @unknown default:
            print("Unknown")
        }
    }
    
    func startScanning(_ iotDevice: IotDevice)->Void
    {
        print("start scanning")
        print("\(iotDevice.deviceInfo.bleServiceUUID)")
        self.deviceInfo = iotDevice.deviceInfo
        self.BLE_Service_uuid = CBUUID(string: iotDevice.deviceInfo.bleServiceUUID)
        self.BLE_Characteristic_uuid_Rx = CBUUID(string: iotDevice.deviceInfo.bleCharacteristicRxUUID)
        self.BLE_Characteristic_uuid_Tx = CBUUID(string: iotDevice.deviceInfo.bleCharacteristicTxUUID)
        centralManager.scanForPeripherals(withServices: [CBUUID(string: iotDevice.deviceInfo.bleServiceUUID)], options: nil)
    }
    
    func stopScanning()->Void
    {
        print("stop scanning")
        centralManager.stopScan()
    }
    
    func disconnect()->Void
    {
        centralManager.cancelPeripheralConnection(blePeripheral)
    }
    
    func connectService()->Void
    {
        print("\(String(describing: self.BLE_Service_uuid))")
        blePeripheral.discoverServices([self.BLE_Service_uuid])
    }
    
    func didDiscoverService(){
        
        guard let services = blePeripheral.services else {
            return
        }
        print("services discovered: \(services)")
        //We need to discover the all characteristic
        for service in services {
            blePeripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discovered Services: \(services)")
    }
    
    func updateRSSI()
    {
        self.blePeripheral.readRSSI()
    }
    
    
    
    func jsonConverter(jsonDataFromSensor: String)->DataModel
    {
        let jsonData = jsonDataFromSensor.data(using: .utf8)!
        let decoder = JSONDecoder()
        print("jsonConverter\(jsonData)")
        if let objectDataDecoded = try? decoder.decode(DataModel?.self, from: jsonData){return objectDataDecoded } else{
            
            return DataModel(SHT31_TEMP:1.1, SHT31_HUMID: 1.1, Switch1State: 0, Switch2State: 0)
        }
    }
    
    
    
    
    
}



class dataToSwiftData
{
    var data = [DataModel]()
    
    func sendDataToSwiftData(data: DataModel)
    {
        self.data.append(data)
    }
}
