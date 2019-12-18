//
//  AddCityViewController.swift
//  Uutu
//
//  Created by admin on 17/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import UIKit
import RealmSwift

class AddCityViewController: UIViewController {

    @IBOutlet weak var searchController: UISearchBar!
    @IBOutlet weak var cityNameTableView: UITableView!
    
    var cityNames : [CityWeather]?
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.resignFirstResponder()
    }
    
    fileprivate func initView() {
        
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


    // MARK: - TableView datasource and delegete

extension AddCityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityNames?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = self.cityNames?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCityTableViewCell.identifier, for: indexPath) as? SearchCityTableViewCell else {
            return UITableViewCell()
        }
        cell.cityName = city?.cityName
        return cell
    }
}

extension AddCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let city = self.cityNames?[indexPath.row] ?? CityWeather()
            CityWeather.storeWeather(weather: city, realm: self.realm)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

    //MARK: - Search Controller Delegate

extension AddCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchCity = searchBar.text ?? ""
        weatherResponse.getWeatherWithCityName(cityName: searchCity) { [weak self] cityNames in
            if cityNames?.count ?? 0 > 0{
                self?.cityNames = cityNames
                self?.cityNameTableView.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
