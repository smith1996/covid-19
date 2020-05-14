//
//  InformationResponse.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/27/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

internal struct FeatureResponse: Codable {
    
    var type: String
    var listOfFeatures: [FeatureCountryData]?
    
    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case listOfFeatures = "features"
    }
    
}

