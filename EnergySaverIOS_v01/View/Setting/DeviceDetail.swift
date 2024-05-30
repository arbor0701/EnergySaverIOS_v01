//
//  BluetoothConnect.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/21/24.
//

import SwiftUI
import SwiftData
struct DeviceDetail: View {
    
    
    @Bindable var iotDevice: IotDevice
    @State private var serialNo: String = ""
    
    var body: some View {

            Form{
                Section(header: Text("Device Info"))
                {
                    TextField("Id", value: $iotDevice.deviceInfo.id, formatter: NumberFormatter())
                    TextField("Name", text:  $iotDevice.deviceInfo.name )
                    TextField("BLE Service UUID", text: $iotDevice.deviceInfo.bleServiceUUID)
                    TextField("BLE Characteristic Rx UUID", text: $iotDevice.deviceInfo.bleCharacteristicRxUUID)
                    TextField("BLE Characteristic Tx UUID", text: $iotDevice.deviceInfo.bleCharacteristicTxUUID)
                }
                Section(header: Text("Add Serial No."))
                {
                    TextEditor(text: $iotDevice.serialNo)
                }
                
            }
        .navigationTitle("Device Detail")
    }
    

}

#Preview {
    do
    {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: IotDevice.self, configurations: config)
        let example = IotDevice(deviceInfo: DeviceInfo(id: 1, name: "Device1", bleServiceUUID: "ServiceUUID", bleCharacteristicRxUUID: "RxUUID", bleCharacteristicTxUUID: "TxUUID"))
        
        return DeviceDetail(iotDevice: example)
            .modelContainer(container)
    }
    catch{
        return Text("Error: \(error)")
    }
    
}
