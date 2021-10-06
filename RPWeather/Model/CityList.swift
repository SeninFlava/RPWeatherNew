//
//  CityList.swift
//  RPWeather
//
//  Created by Alexander Senin on 05.10.2021.
//

import Foundation


class City {
    
    var name: String
    var lat: Double
    var lon: Double
    
    init(name: String, lat: Double, lon: Double) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
    
}

var cities: [City] = []

class CityParser {
    /*
     
    [
    {
        "id": 833,
        "name": "Ḩeşār-e Sefīd",
        "state": "",
        "country": "IR",
        "coord": {
            "lon": 47.159401,
            "lat": 34.330502
        }
    }
     ,
     ...
     ]
     */
    
    func parse() {
        if let data = try? NSData(contentsOfFile: Bundle.main.path(forResource: "city.list", ofType: "json")!) as Data {
            let arrayCities = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [[String: Any]]
            
            for cityDict in arrayCities ?? [] {
                let name = cityDict["name"] as? String ?? ""
                let lat = (cityDict["coord"] as? [String: Double])?["lat"] ?? 0
                let lon = (cityDict["coord"] as? [String: Double])?["lon"] ?? 0
                
                let city = City(name: name, lat: lat, lon: lon)
                cities.append(city)
            }
            
        }
        
    }
    
}
