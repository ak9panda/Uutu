//
//  ViewController.swift
//  Uutu
//
//  Created by admin on 13/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var cityTableView: UITableView!
    
    var cityWeather : Results<CityWeather>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView() {
        let cityWeather = realm.objects(CityWeather.self)
        if cityWeather.isEmpty {
            fetchWeather()
        }else{
            self.cityWeather = cityWeather
        }
    }
    
    fileprivate func fetchWeather() {
        weatherResponse.getWeatherWithLocation(latitude: 16.871311, longitude: 96.199379) { [weak self] cityWeather in
            cityWeather?.forEach({ weather in
                CityWeather.storeWeather(weather: weather, realm: self!.realm)
            })
        }
    }
}

extension MainViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = cityWeather?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityNameTableViewCell.identifier, for: indexPath) as? CityNameTableViewCell else {
            return UITableViewCell()
        }
        cell.cityName = weather?.cityName
        return cell
    }
}

extension MainViewController : UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? WeatherDetailViewController {
            if let indexPaths = cityTableView.indexPathForSelectedRow, indexPaths.count > 0 {
                
            }
        }
    }
}
