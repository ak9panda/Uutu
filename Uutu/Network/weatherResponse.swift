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
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/find") else { completion([CityWeather]()); return }
        let apikey = "5e1f4878fc96b5799ba27958561aad33"
        let params = ["lat": latitude, "lon": longitude, /*"cnt": 100.0,*/ "appid": apikey] as [String : Any]
        AF.request(url, parameters: params)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(_):
                debugPrint("\(response.result)")
                let jsonVar = try! JSON(data:response.data!)
                let weather = translateJSON(data: jsonVar)
                completion(weather)
            case let .failure(error):
                print(error)
            }
//            (responseData) -> Void in
//            let swiftyJsonVar = JSON(responseData.result)
//            let cityWeather = translateJSON(data: swiftyJsonVar)
//            completion(cityWeather)
        }.resume()
    }
    
    static func translateJSON (data : JSON) -> [CityWeather]? {
        if let jsonCities = data["list"].array {
            var cityWeatherArray = [CityWeather]()
            for weather in jsonCities {
                let city = CityWeather()
                city.cityName = weather["name"].string
                city.temperature = weather["main"]["temp"].double ?? 0.0
                city.pressure = weather["main"]["pressure"].double ?? 0.0
                city.humidity = weather["main"]["humidity"].double ?? 0.0
                cityWeatherArray.append(city)
            }
            return cityWeatherArray
        }
        return nil
    }
}
