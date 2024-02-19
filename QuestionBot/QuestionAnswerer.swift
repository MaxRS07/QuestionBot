import Foundation

struct MyQuestionAnswerer {
    private let cities = CSVReader().CSVtoStruct(from: "worldcities") //cache it
    func responseTo(question: String, callback : @escaping (_ data : String)->Void){
        var weatherBuilder : [String] = []
        for i in question.split(separator: " ") {
            let word = String(i).lowercased().normalString()
            if weatherKeys.contains(word) {
                for i in question.split(separator: " ") {
                    let word2 = String(i).lowercased().normalString()
                    if commonWords.contains(word2) || word2 == word || weatherKeys.contains(word2) {
                        continue
                    } else {
                        weatherBuilder.append(word2)
                    }
                }
                if let a = advancedLocationSearch(location: weatherBuilder.joined()) {
                    Weatherize(s: a, a: "") { data in
                        if a.country.normalString().lowercased() == "united states" {
                            callback("it is \(data)°C in \(a.city.normalString()), \(a.region.normalString())")
                        } else {
                            callback("it is \(data)°C in \(a.city.normalString()), \(a.country.normalString())")
                        }
                    }
                    return
                } else {
                    callback("location not found")
                }
                return
            }
            else if mathKeys.contains(word) {
                
            }
        }
        Cohere.generate(prompt: question) { response in
            if let text = response?.generations?.first?.text {
                callback(text)
                return
            } else {
                callback("An error has occured please try again later")
                return
            }
        }
    }
    func Weatherize(s : Structs.City, a : String, send : @escaping (String)->Void) {
        WeatherHandler.sharedInstance.getWeather(lat: s.lat, lon: s.long, units: "Metric") {safeData in
            send(String(safeData.main!.temp))
        }
    }
    func advancedLocationSearch(location : String) -> Structs.City? {
        let a = cities.filter({($0.country + $0.city + $0.region).lowercased().normalString().replacingOccurrences(of: " ", with: "").contains(location)})
        if a.isEmpty {
            return nil
        }
        return closestMatch(options: a, target: location)
    }
    func closestMatch(options : [Structs.City], target : String) -> Structs.City? {
        for i in options {
            var name = (i.city + i.country + i.region).normalString().lowercased().replacingOccurrences(of: " ", with: "")
            
            if name.contains(target) { //TODO make this smarter or dont idk
                return i
            }
        }
        return nil
    }
    let weatherKeys : [String] = [
        "weather",
        "temperature",
        "high",
        "low",
        "feel"
    ]
    let commonWords = ["the","of","and","a","to","in","is","you","that","it","he","was","for","on","are","as","with","his","they","I","at","be","this","have","from","or","one","had","by","word","but","not","what","all","were","we","when","your","can","said","there","use","an","each","which","she","do","how","their","if","will","up","other","about","out","many","then","them","these","so","some","her","would","make","like","him","into","time","has","look","two","more","write","go","see","number","no","way","could","people","my","than","first","water","been","call","who","oil","its","now","find","long","down","day","did","get","come","made","may","part", "does"]
}
extension String {
    func normalString() -> String {
        let a : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(self.filter {a.contains($0) })
    }
}
