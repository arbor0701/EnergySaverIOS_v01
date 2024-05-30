
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
                peripheralSelected.startScanning(iotDevice)
            }, label: {
                Text(peripheralSelected.bleConnectionStatus)
            })
            
            Text(String(iotDevice.data.last?.SHT31_TEMP ?? 0.0))
        }
        .task{
            iotDevice.data.append(peripheralSelected.sensorDataDecoded)
        }
//        .onChange(of:dataFromBle){ oldData,newData in
//            DispatchQueue.main.async {
//                iotDevice.data.append(DataModel(SHT31_TEMP: newData.SHT31_TEMP, SHT31_HUMID: newData.SHT31_HUMID, Switch1State: newData.Switch1State, Switch2State: newData.Switch2State))
//            }
//            
//        }
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
