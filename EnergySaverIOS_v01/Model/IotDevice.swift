
import Foundation
import SwiftData

@Model
final class IotDevice
{

    var deviceInfo: DeviceInfo
    var connected: Bool
    var data:[DataModel]
    var updatedDate: Date = Date()
 
    init(deviceInfo: DeviceInfo,data:[DataModel])
    {
        self.deviceInfo = deviceInfo
        self.connected = false
        self.data = data
    }
    

}

struct DeviceInfo:Codable,Hashable
{
    var id: Int
    var name: String
    var bleServiceUUID:String
    var bleCharacteristicRxUUID:String
    var bleCharacteristicTxUUID:String
}

struct DataModel:Codable,Hashable
{
    var Temp: Float = 0.0
    var Humid: Float = 0.0
    var Switch1State: Int = 0
    var Switch2State: Int = 0
}


//@Model
//final class IotDevice:Codable,Hashable,Identifiable
//{
//
//    var id: Int
//    var name:String
//    var type:String
//    var data:[DeviceDataModel]
//    enum CodingKeys: String, CodingKey
//    {
//        case id
//        case name
//        case type
//        case data
//    }
//
//    init(id:Int,name:String,type:String,data:[DeviceDataModel])
//    {
//        self.id = id
//        self.name = name
//        self.type = type
//        self.data = data
//    }
//
//
//    required init(from decoder: Decoder) throws
//    {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        type = try container.decode(String.self, forKey: .type)
//        data = try container.decode([DeviceDataModel].self, forKey: .data)
//    }
//    
//    func encode(to encoder: Encoder) throws
//    {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(type, forKey: .type)
//        try container.encode(data, forKey: .data)
//    }
//    
//    struct DeviceDataModel: Codable,Hashable
//    {
//        var deviceData1: Float = 0.0
//        var deviceData2: Float = 0.0
//        var deviceData3: Float = 0.0
//        var deviceData4: Float = 0.0
//    }
//}
//
