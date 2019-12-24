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
    var cityNames : [String] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.activityStartAnimating()
        initView()
        cityTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func handleRefresh(_ refreshControl : UIRefreshControl) {
        reloadWeather()
        cityTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func initView() {
        let cityWeather = realm.objects(CityWeather.self)
        if cityWeather.isEmpty {
            fetchWeather()
            cityTableView.reloadData()
        }else{
            self.cityWeather = cityWeather
            cityTableView.reloadData()
        }
        self.view.activityStopAnimating()
    }
    
    fileprivate func fetchWeather() {
        weatherResponse.getWeatherWithLocation(latitude: 16.871311, longitude: 96.199379) { [weak self] cityWeather in
            cityWeather?.forEach({ weather in
                CityWeather.storeWeather(weather: weather, realm: self!.realm)
            })
        }
    }
    
    fileprivate func reloadWeather() {
        cityWeather?.enumerated().forEach({ (i, weather) in
            let name = weather.cityName
            cityNames.append(name ?? "")
        })
        try! realm.write {
            realm.delete(realm.objects(CityWeather.self))
        }
        cityNames.forEach({ name in
            weatherResponse.getWeatherWithCityName(cityName: name) { [weak self] weather in
                CityWeather.storeWeather(weather: weather!, realm: self!.realm)
            }
        })
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
        let intTemp = Int(weather?.temperature ?? 0.0)
        let celcius = intTemp - 273
        cell.cityTemp = String(celcius)
        return cell
    }
}

extension MainViewController : UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? WeatherDetailViewController {
            if let indexPaths = cityTableView.indexPathForSelectedRow, indexPaths.count > 0 {
                viewController.id = cityWeather?[indexPaths.row].id ?? 0
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let weather = cityWeather![indexPath.row]
            try! realm.write {
                realm.delete(weather)
            }
            cityTableView.reloadData()
        }
    }
}
