
import Foundation
@Observable
class DeviceRegisterable
{
  
    var devicesInfo: [DeviceInfo]?
    
    init()
    {
        self.devicesInfo = decodeJson("deviceInfo.json")
    }
    
    func decodeJson<T:Decodable>(_ filename: String) -> T
    {  
        let data:Data
        let jsonDecoder = JSONDecoder()
        guard let jsonFile = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do{
            data = try Data(contentsOf: jsonFile)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do{
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    
    }
    
    
}

