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
    @IBOutlet weak var lblCityName: UILabel!
    
    var cityName : CityWeather?
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.resignFirstResponder()
    }
    
    fileprivate func initView() {
        lblCityName.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddCityViewController.tapLabel))
        lblCityName.isUserInteractionEnabled = true
        lblCityName.addGestureRecognizer(tap)
    }
    
    @objc func tapLabel(sender:UITapGestureRecognizer) {
        DispatchQueue.main.async {
            CityWeather.storeWeather(weather: self.cityName ?? CityWeather(), realm: self.realm)
        }
        self.dismiss(animated: true, completion: nil)
    }

}

    //MARK: - Search Controller Delegate

extension AddCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchCity = searchBar.text ?? ""
        weatherResponse.getWeatherWithCityName(cityName: searchCity) { [weak self] cityName in
            if cityName != nil{
                self?.cityName = cityName
                self?.lblCityName.isHidden = false
                self?.lblCityName.text = cityName?.cityName
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
