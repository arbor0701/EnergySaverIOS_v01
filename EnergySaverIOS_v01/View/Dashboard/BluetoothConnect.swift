
import SwiftUI
import SwiftData
import CoreBluetooth

struct BluetoothConnect: View {
    @Bindable var iotDevice:IotDevice
    @Bindable var peripheralSelected:BLEconnecting
    
    var body: some View {
        @State var dataFromBle = peripheralSelected.sensorDataDecoded
        
        HStack{
            Image(systemName: "antenna.radiowaves.left.and.right")
                .foregroundColor(peripheralSelected.bleConnectionStatus == "connected" ? .green : .red)
            Text(iotDevice.deviceInfo.name)
            Button(action: {
                if peripheralSelected.bleConnectionStatus == "connected" {
                    peripheralSelected.disconnect()
                }
                else
                {
                    peripheralSelected.startScanning(iotDevice)}
            }, label: {
                Text(peripheralSelected.bleConnectionStatus)
            })
            
            Text(String(iotDevice.data.last?.SHT31_TEMP ?? 0.0))
        }

    }
}

#Preview {
    do
    {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: IotDevice.self, configurations: config)
        let example = IotDevice(deviceInfo: DeviceInfo(id: 1, name: "Device1", bleServiceUUID: "ServiceUUID", bleCharacteristicRxUUID: "RxUUID", bleCharacteristicTxUUID: "TxUUID"))
        
        return BluetoothConnect(iotDevice: example, peripheralSelected: BLEconnecting())
            .modelContainer(container)
    }
    catch{
        return Text("Error: \(error)")
    }
}
