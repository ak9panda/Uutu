//
//  SearchCityTableViewCell.swift
//  Uutu
//
//  Created by admin on 18/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import UIKit

class SearchCityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    
    var cityName : String? {
        didSet{
            if let name = cityName {
                lblCityName.text = name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var identifier : String {
        return String(describing: self)
    }

}
