//
//  weatherResponse.swift
//  Uutu
//
//  Created by admin on 13/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

struct weatherResponse {
    
    static func getWeatherWithLocation(latitude : Double, longitude : Double, completion : @escaping([CityWeather]?) -> Void) {
        guard let url = URL(string: "\(API.BASE_URL)/find") else { completion([CityWeather]()); return }
        let params = ["lat": latitude, "lon": longitude, /*"cnt": 100.0,*/ "appid": API.KEY] as [String : Any]
        AF.request(url, parameters: params)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(_):
                debugPrint("\(response.result)")
                let jsonVar = try! JSON(data:response.data!)
                let weather = translateJSONList(data: jsonVar)
                completion(weather)
            case let .failure(error):
                print(error)
            }
        }.resume()
    }
    
    static func getWeatherWithCityName(cityName : String, completion : @escaping(CityWeather?) -> Void) {
        guard let url = URL(string: "\(API.BASE_URL)/weather") else { completion(CityWeather()); return }
        let params = ["q": cityName, "appid": API.KEY]
        AF.request(url, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    let jsonVar = try! JSON(data:response.data!)
                    let weather = translateJSON(data: jsonVar)
                    completion(weather)
                case let .failure(error):
                    print(error)
                }
        }.resume()
    }
    
    static func translateJSONList (data : JSON) -> [CityWeather]? {
        if let jsonCities = data["list"].array {
            var cityWeatherArray = [CityWeather]()
            for weather in jsonCities {
                let city = CityWeather()
                city.id = weather["id"].int ?? 0
                city.cityName = weather["name"].string
                let weatherArray = weather["weather"]
                city.weatherStatus = weatherArray[0]["description"].string
                city.weatherIcon = weatherArray[0]["icon"].string
                city.miniTemp = weather["main"]["temp_min"].double ?? 0.0
                city.temperature = weather["main"]["feels_like"].double ?? 0.0
                city.maxTemp = weather["main"]["temp_max"].double ?? 0.0
                city.pressure = weather["main"]["pressure"].double ?? 0.0
                city.humidity = weather["main"]["humidity"].double ?? 0.0
                city.wind = weather["wind"]["speed"].int ?? 0
                cityWeatherArray.append(city)
            }
            return cityWeatherArray
        }
        return nil
    }
    
    static func translateJSON(data: JSON) -> CityWeather? {
        if(data["cod"] == 200){
            let weather = CityWeather()
            weather.id = data["id"].int ?? 0
            weather.cityName = data["name"].string
            let weatherArray = data["weather"]
            weather.weatherStatus = weatherArray[0]["description"].string
            weather.weatherIcon = weatherArray[0]["icon"].string
            weather.miniTemp = data["main"]["temp_min"].double ?? 0.0
            weather.temperature = data["main"]["feels_like"].double ?? 0.0
            weather.maxTemp = data["main"]["temp_max"].double ?? 0.0
            weather.pressure = data["main"]["pressure"].double ?? 0.0
            weather.humidity = data["main"]["humidity"].double ?? 0.0
            weather.wind = data["wind"]["speed"].int ?? 0
            
            return weather
        }else{
            print("failed to parse data")
            return nil
        }
    }
}
