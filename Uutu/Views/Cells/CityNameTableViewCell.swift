//
//  CityNameTableViewCell.swift
//  Uutu
//
//  Created by admin on 16/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import UIKit
import Foundation

class CityNameTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCityTemp: UILabel!
    
    var cityName : String? {
        didSet{
            if let cityName = cityName {
                lblCityName.text = cityName
            }
        }
    }
    
    var cityTemp : String? {
        didSet{
            if let cityTemp = cityTemp {
                lblCityTemp.text = "\(cityTemp) °C"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier : String {
        return String(describing: self)
    }

}
