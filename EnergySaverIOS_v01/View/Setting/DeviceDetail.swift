//
//  BluetoothConnect.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/21/24.
//

import SwiftUI

struct DeviceDetail: View {
    @State var deviceInfo: DeviceInfo
    @State private var serialNo: String = ""
    
    var body: some View {
        Form{
            Section(header: Text("Device Info"))
            {
                TextField("Id", value: $deviceInfo.id, formatter: NumberFormatter())
                TextField("Name", text: $deviceInfo.name)
                TextField("BLE Service UUID", text: $deviceInfo.bleServiceUUID)
                TextField("BLE Characteristic Rx UUID", text: $deviceInfo.bleCharacteristicRxUUID)
                TextField("BLE Characteristic Tx UUID", text: $deviceInfo.bleCharacteristicTxUUID)
            }
            Section(header: Text("Serial No."))
            {
                TextField("Serial No." , text: $serialNo)
            }
      
        }
    }
}

#Preview {
    DeviceDetail( deviceInfo: DeviceInfo(id: 1, name: "Device 1", bleServiceUUID: "Service UUID", bleCharacteristicRxUUID: "Rx UUID", bleCharacteristicTxUUID: "Tx UUID"))
}
