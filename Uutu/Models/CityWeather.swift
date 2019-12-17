//
//  CityWeather.swift
//  Uutu
//
//  Created by admin on 13/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class CityWeather: Object {
    dynamic var id : Int = 0
    dynamic var cityName : String?
    dynamic var weatherStatus : String?
    dynamic var weatherIcon : String?
    dynamic var miniTemp : Double = 0.0
    dynamic var maxTemp : Double = 0.0
    dynamic var temperature : Double = 0.0
    dynamic var pressure : Double = 0.0
    dynamic var humidity : Double =  0.0
    dynamic var wind : Int = 0
    
    override static func primaryKey() -> String?{
        return "id"
    }
}

extension CityWeather {
    static func getWeatherWithId(id : Int, realm : Realm) -> CityWeather? {
        return realm.object(ofType: CityWeather.self, forPrimaryKey: id)
    }
    
    static func storeWeather(weather : CityWeather, realm : Realm) {
        do{
            try realm.write {
                realm.add(weather, update: .modified)
            }
        }catch{
            print("Error: \(error.localizedDescription) cannot save")
        }
    }
}
