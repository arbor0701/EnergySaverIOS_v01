
import SwiftUI
import SwiftData
struct Indicator: View {
    let widthRatio = 4.5

    @Bindable var iotDevice: IotDevice
    @Bindable var peripheralSelected:BLEconnecting
    @State private var settingTemp: CGFloat = 0.0
    @State private var settingHumid: CGFloat = 0.0
    
    var body: some View {
        
        @State var dataFromBle = peripheralSelected.sensorDataDecoded

        HStack{

            ZStack()
            {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Color.blue)
                    .frame(width:(screenWidth/5), height: 100)
                    .shadow(radius: 5)
                
                VStack{
                    Text("Temp")
                        .font(.body)
                        .foregroundColor(.white)
                    Text(String(dataFromBle.SHT31_TEMP))
                        .font(.body)
                        .foregroundColor(.white)

                    Text("Celsius")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            SliderV01( symbol:"°", progressRange: 30,peripheralSelected: peripheralSelected, settingValue: $settingTemp)
            ZStack()
            {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Color.blue)
                    .frame(width:(screenWidth/5), height: 100)
                    .shadow(radius: 5)
                VStack{
                    Text("Humid")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text(String(dataFromBle.SHT31_HUMID))
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("%")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            SliderV01(symbol:"%", progressRange: 100,peripheralSelected: peripheralSelected ,settingValue: $settingHumid)

        }.onChange(of:settingTemp){
            peripheralSelected.writeValue(data: "{ \"Temp\":\(Int(settingTemp)) , \"Humid\":\(Int(settingHumid))}")
        }
        .onChange(of:settingHumid){
            peripheralSelected.writeValue(data: "{ \"Temp\":\(Int(settingTemp)) , \"Humid\":\(Int(settingHumid))}")
        }
  
   
    }
    func fetchData(for query: CGFloat) async throws {
           // Simulate a network or database query delay
//           try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
           
           // Simulated fetched data
//           let fetchedData = ["Item 1", "Item 2", "Item 3"]
           
           // Update data on the main thread
           await MainActor.run {
               iotDevice.tempSet = Float(query)
           }
       }
    
}


#Preview {
    do
    {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: IotDevice.self, configurations: config)
        let example = IotDevice(deviceInfo: DeviceInfo(id: 1, name: "Device1", bleServiceUUID: "ServiceUUID", bleCharacteristicRxUUID: "RxUUID", bleCharacteristicTxUUID: "TxUUID"))
        
        return Indicator(iotDevice: example, peripheralSelected: BLEconnecting())
            .modelContainer(container)
    }
    catch{
        return Text("Error: \(error)")
    }
}
