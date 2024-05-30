
import SwiftUI
import SwiftData

struct DeviceRegister: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort:[SortDescriptor(\IotDevice.deviceInfo.id) ])  var iotDevices: [IotDevice]
  
    var body: some View{
        NavigationStack
        {
            List{
                ForEach(iotDevices)
                {
                    iotDevice in
                    
                    NavigationLink{
                        DeviceDetail(iotDevice: iotDevice)
                    } label : {
                            Text(iotDevice.deviceInfo.name)
                    }

                }.onDelete(perform: {indexSets in
                  
                        removeDeviceInfoFromSwiftData(indexSets) }
                )
            }
            .navigationBarTitle("Devices")
            .toolbar{
                ToolbarItem {
                    EditButton()
                }
            }
        }
        .onAppear(perform: addDeviceInfoToSwiftDataFromServer)
    
    }

    func addDeviceInfoToSwiftDataFromServer(){
        print("addDeviceInfoToSwiftDataFromServer")
        let devicesInfo = DeviceRegisterable().devicesInfo
        if(devicesInfo != nil)
        {
            devicesInfo!.forEach{
                deviceInfo in
                if(iotDevices.contains(where: {$0.deviceInfo.id == deviceInfo.id})) { print("Device already registered") }
                else{
                    let newDevice = IotDevice(deviceInfo: deviceInfo)
                    modelContext.insert(newDevice)}
            }
        }
 
    }
    
    func removeDeviceInfoFromSwiftData(_ offsets: IndexSet){
        offsets.forEach{
            index in
            modelContext.delete(iotDevices[index])
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    var body: some View {
//        if devicesRegistered.devicesInfo == nil
//        {
//            Text("No devices registered")
//        }
//        else {
//            
//            NavigationStack
//            {
//                List{
//                    ForEach(devicesRegistered.devicesInfo!)
//                    {
//                        device in
//                        HStack{
//                            Text(device.name)
//                            Spacer()
//          
//                            
//                            NavigationLink(destination: DeviceDetail(deviceInfo: device))
//                            {
//                                Spacer()
//                                Text(
//                               iotDevices.contains(where: {$0.deviceInfo.id == device.id}) ? "Registered" :
//                                    "Add Device Serial No.")
//                                .foregroundColor(.blue)
//                                
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("My devices")
//            }
//            
//            
//            
//            
//        }
//        
//    }
//    
    
}

#Preview {
    DeviceRegister().modelContainer(for:IotDevice.self, inMemory: true)
    
}
