
import SwiftUI
import SwiftData
import CoreBluetooth

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct Dashboard: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:[SortDescriptor(\IotDevice.deviceInfo.id)])  var iotDevices: [IotDevice]
    
    var body: some View {
        VStack{
            ForEach(iotDevices)
            {
                iotDevice in
                
                let peripheralSelected = BLEconnecting()
                BluetoothConnect(iotDevice: iotDevice, peripheralSelected: peripheralSelected)
                Indicator(iotDevice: iotDevice, peripheralSelected: peripheralSelected)
            }
        }
    }
}

#Preview {
    Dashboard().modelContainer(for:IotDevice.self, inMemory: true)
}
