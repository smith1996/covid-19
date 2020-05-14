//
//  CountryData.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/4/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

internal struct CountryData: Codable {
    var country: String = ""
    
    public enum CodingKeys: String, CodingKey {
        case country = "country"
    }
}
