//
//  File.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/7/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

internal struct CountryResponse: ReusedAttributes, Codable {
    
    var title: String
    //var country: [CountryData]?
    var totalAmount: Int
    var listOfCountries: [String]?
    
    public enum CodingKeys: String, CodingKey {
        case title = "get"
        //case country = "parameters"
        case totalAmount = "results"
        case listOfCountries = "response"
    }
}
