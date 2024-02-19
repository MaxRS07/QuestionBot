
import Foundation

public class CSVReader{
    public func CSVtoStruct(from fileName: String) -> [Structs.City] {
        var objects = [Structs.City]()
        
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {return []}
        
        var data = ""
        do{
            data = try String(contentsOfFile: filePath)
        } catch {print(error)}
        
        let rows = data.components(separatedBy: "\n")
        for row in rows{
            if row.count >= 5 {
                let csvColumn = row.components(separatedBy: ",")
                let cityStruct = Structs.City(raw: csvColumn)
                objects.append(cityStruct)
            }   
        }
        return objects
    }
}
