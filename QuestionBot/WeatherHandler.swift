//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Max Siebengartner on 20/6/2023.
//

import Foundation



public final class WeatherHandler{
    
    public static let sharedInstance = WeatherHandler()
    
    public func getWeather(lat: Double, lon: Double, units: String, callback: @escaping (_ safeData: Structs.WeatherData) -> Void){
        let key = "decb0876ee2c30120a0648422cd6e414"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)&units=\(units)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error accessing swapi.co: /(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response!)")
                return
            }
            if let data = data {
                let SafeData = self.parseJSON(data: data)
                callback(SafeData!)
            }
            
        })
        
        task.resume()
    }
    public func getWeatherForecast(lat: Double, lon: Double, units: String, callback: @escaping (_ safeData: ForecastData) -> Void){
        let key = "decb0876ee2c30120a0648422cd6e414"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(key)&units=\(units)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("Error accessing swapi.co: /(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response!)")
                return
            }
            if let data = data {
                if let SafeData = self.parseJSON2(data: data) {
                    callback(SafeData)
                }
                else {
                    return
                }
                
            }
            
        })
        
        task.resume()
    }
    public func parseJSON(data: Data) -> Structs.WeatherData?{
        do{
            let newData = try  JSONDecoder().decode(Structs.WeatherData.self, from: data)
            return newData
        } catch {
            print(error)
        }
        return nil
    }
    public func parseJSON2(data: Data) -> ForecastData?{
        do{
            let newData = try JSONDecoder().decode(ForecastData.self, from: data)
            return newData
        } catch {
            print(error)
        }
        return nil
    }
}

