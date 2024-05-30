//
//  Indicator.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/21/24.
//

import SwiftUI
import SwiftData
struct Indicator: View {
    let widthRatio = 4.5

    @Bindable var iotDevice: IotDevice
    @Bindable var peripheralSelected:BLEconnecting

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
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Celsius")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            ZStack()
            {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Color.blue)
                    .frame(width:(screenWidth/5), height: 100)
                    .shadow(radius: 5)
                
                VStack{
                    Text("TempSet")
                        .font(.body)
                        .foregroundColor(.white)
                    Text(String(dataFromBle.SHT31_TEMP))
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Celsius")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
         
            
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
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("%")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            ZStack()
            {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Color.blue)
                    .frame(width:(screenWidth/5), height: 100)
                    .shadow(radius: 5)
                VStack{
                    Text("HumidSet")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text(String(dataFromBle.SHT31_HUMID))
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("%")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

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
