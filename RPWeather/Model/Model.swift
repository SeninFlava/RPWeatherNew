//
//  Model.swift
//  RPWeather
//
//  Created by Alexander Senin on 04.10.2021.
//

//http://api.openweathermap.org/data/2.5/find?lat=55.5&lon=37.5&cnt=1&appid=1b29144ee69ef0a94f8b0c2a7a1aa998
//-273,15

//http://api.openweathermap.org/data/2.5/forecast/daily?lat=55.5&lon=36.6&cnt=10&appid=1b29144ee69ef0a94f8b0c2a7a1aa998

//иконка
//http://openweathermap.org/img/w/10d.png

import Foundation


struct WeatherData {
    var city: String
    var iconCode: String
    var iconUrl: String {
        "http://openweathermap.org/img/w/\(iconCode).png"
    }
    
    var degreesKelvin: Double
    var degreesCelsiy: String {
        
        let c = Int(degreesKelvin - 273.15)
        if c > 0 {
            return "+" + String(c)
        } else {
            return String(c)
        }
        
    }
}



struct DayTemperature {
    var day: Double
    var degreesKelvin: Double
    var degreesCelsiy: String {
        let c = Int(degreesKelvin - 273.15)
        if c > 0 {
            return "+" + String(c)
        } else {
            return String(c)
        }
    }
    
    var dayString: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        
        return df.string(from: Date(timeIntervalSince1970: day))
    }
}


struct WeatherDailyData {
    var city: String
    var daysTemperature: [DayTemperature]
}





class Model {
    
    private var apiKey = "1b29144ee69ef0a94f8b0c2a7a1aa998"
    private func urlCurrentWeatherString(lat: Double, lon: Double) -> String {
        return "http://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(lon)&cnt=1&appid=\(apiKey)"
    }
    private var pathForCurrentWeatherJSON = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/" + "weather.json"

    
    
    private func urlDaylyWeatherString(lat: Double, lon: Double) -> String {
        return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=10&appid=\(apiKey)"
    }
    private var pathForDailyWeatherJSON = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/" + "weatherDaily.json"

    
    
    
    
    
    private func downloadJSON(urlString: String, pathForSave: String, completionHandler: @escaping (_ error: String?)->Void) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: URL(string: urlString)!) { data, responce, error in
            if let error = error {
                //print(error.localizedDescription)
                completionHandler(error.localizedDescription)
                return
            }
            
            if data == nil {
                //print("data = nil")
                completionHandler("Что-то пошло не так...")
                return
            }
            
            try? FileManager.default.removeItem(atPath: pathForSave)
            
            if (data as NSData?)?.write(toFile: pathForSave, atomically: true) == true {
                print("Корректно скачали JSON")
                print(pathForSave)
                completionHandler(nil)

            } else {
                //print("Ошибка записи файла")
                completionHandler("Что-то пошло не так...")
                
            }
            
        }

        task.resume()
    }
    
    
    
    
    
    
 /*
  {"message":"accurate","cod":"200","count":1,"list":[{"id":495260,"name":"Shcherbinka","coord":{"lat":55.4997,"lon":37.5597},"main":{"temp":276.8,"feels_like":275.79,"temp_min":273.73,"temp_max":279.9,"pressure":1030,"humidity":89},"dt":1633374544,"wind":{"speed":1.34,"deg":80},"sys":{"country":"RU"},"rain":null,"snow":null,"clouds":{"all":18},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}]}]}
  */

    private func parseCurrentWeatherJSON() -> WeatherData? {
        let dictJson = try? JSONSerialization.jsonObject(with: NSData(contentsOfFile: pathForCurrentWeatherJSON) as Data, options: .allowFragments) as? [String: Any]
        
        let dictCity = (dictJson?["list"] as? [[String: Any]])?[0]
        
        if let name = dictCity?["name"] as? String ,let temp = (dictCity?["main"] as? [String: Double])?["temp"] {
            print(name)
            print(temp)
            
            var iconCode = ""
            if let iconJson = (dictCity?["weather"] as? [[String: Any]])?[0]["icon"] as? String {
                iconCode = iconJson
            }

            
            return WeatherData(city: name, iconCode: iconCode, degreesKelvin: temp)
        }
        
        
        return nil
    }
    
    func refreshCurrnetWeatherData(lat: Double, lon: Double, completionHandler: @escaping (WeatherData?, _ error: String?)->Void) {
        downloadJSON(urlString: urlCurrentWeatherString(lat: lat, lon: lon), pathForSave: pathForCurrentWeatherJSON) { error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            //парсим
            if let weatherData = self.parseCurrentWeatherJSON() {
                completionHandler(weatherData, nil)
                return
            }
            
            print("json не распарсился, скорее всего поменялся формат")
            completionHandler(nil, "что-то пошло не так...")
        }
        
    }
    
    
    
    /*
     
     {
       "city": {
         "id": 580691,
         "name": "Асаково",
         "coord": {
           "lon": 36.6,
           "lat": 55.5
         },
         "country": "RU",
         "population": 0,
         "timezone": 10800
       },
       "cod": "200",
       "message": 5.4694073,
       "cnt": 5,
       "list": [
         {
           "dt": 1633424400,
           "sunrise": 1633405432,
           "sunset": 1633445996,
           "temp": {
             "day": 281.95,
             "min": 276.07,
             "max": 282.84,
             "night": 280.04,
             "eve": 281.94,
             "morn": 276.6
           },
           "feels_like": {
             "day": 280.06,
             "night": 278.07,
             "eve": 280.17,
             "morn": 274.84
           },
           "pressure": 1040,
           "humidity": 78,
           "weather": [
             {
               "id": 804,
               "main": "Clouds",
               "description": "пасмурно",
               "icon": "04d"
             }
           ],
           "speed": 3.88,
           "deg": 151,
           "gust": 8.87,
           "clouds": 100,
           "pop": 0
         },
     
     
     */
    
    
    
    private func parseDailyWeatherJSON() -> WeatherDailyData? {
        let dictJson = try? JSONSerialization.jsonObject(with: NSData(contentsOfFile: pathForDailyWeatherJSON) as Data, options: .allowFragments) as? [String: Any]
        
        
        let dictCity = dictJson?["city"] as? [String: Any]
        
        
        var nameCity = ""
        if let name = dictCity?["name"] as? String {
            nameCity = name
        }
        
        //print(nameCity)
        var weatherDailyData = WeatherDailyData(city: nameCity, daysTemperature: [])
        
        let arrayDays = dictJson?["list"] as? [[String: Any]]
        
        for d in arrayDays ?? [] {
            if let dateDouble = (d["dt"] as? Double), let degrees = (d["temp"] as? [String: Double])?["day"] {
                //print(dateDouble)
                //print(degrees)

                weatherDailyData.daysTemperature.append(DayTemperature(day: dateDouble, degreesKelvin: degrees))
            }
        }
        
        
        return weatherDailyData
    }
    
    func refreshDailyWeatherData(lat: Double, lon: Double, completionHandler: @escaping (WeatherDailyData?, _ error: String?)->Void) {
        downloadJSON(urlString: urlDaylyWeatherString(lat: lat, lon: lon), pathForSave: pathForDailyWeatherJSON) { error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            //парсим
            if let weatherData = self.parseDailyWeatherJSON() {
                completionHandler(weatherData, nil)
                return
            }
            
            print("json не распарсился, скорее всего поменялся формат")
            completionHandler(nil, "что-то пошло не так...")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}


