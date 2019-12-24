//
//  WeatherDetailViewController.swift
//  Uutu
//
//  Created by admin on 16/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblminimumTemp: UILabel!
    @IBOutlet weak var lblnormalTemp: UILabel!
    @IBOutlet weak var lblmaximumTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    var id : Int = 0
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func initView() {
        if let data = CityWeather.getWeatherWithId(id: id, realm: realm) {
            bindDatatoView(data: data)
        }
    }
    
    fileprivate func bindDatatoView(data : CityWeather) {
        lblCityName.text = data.cityName?.uppercased()
        lblDateTime.text = data.dateTime
        lblWeatherStatus.text = data.weatherStatus?.capitalized
        let imgUrl = "http://openweathermap.org/img/wn/\(data.weatherIcon ?? "10d")@2x.png"
        imgWeatherIcon.sd_setImage(with: URL(string: imgUrl), placeholderImage: nil, options:  SDWebImageOptions.progressiveLoad, completed: nil)
        lblTemperature.text = "\(KelvinTemptoOtherUnit(temp: data.temperature, to: "C"))"
        lblminimumTemp.text = "\(KelvinTemptoOtherUnit(temp: data.miniTemp, to: "C")) °C"
        lblnormalTemp.text = "\(KelvinTemptoOtherUnit(temp: data.temperature, to: "C")) °C"
        lblmaximumTemp.text = "\(KelvinTemptoOtherUnit(temp: data.maxTemp, to: "C")) °C"
        lblPressure.text = "\(data.pressure) hPa"
        lblHumidity.text = "\(data.humidity) %"
        lblWind.text = "\(data.wind) m/s"
    }
    
    fileprivate func KelvinTemptoOtherUnit(temp : Double, to : String) -> Int {
        let intTemp = Int(temp)
        if to == "C" {
            return intTemp - 273
        }else if to == "F" {
            let C = intTemp - 273
            return (9/5)*C + 32
        }else{
            return intTemp
        }
    }
    
    @IBAction func onTouchCloseBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
