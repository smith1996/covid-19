//
//  InfectedCountryData.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/4/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

internal struct InfectedCountryData: Codable {
    var country: String = ""
    var cases: CasesData?
    var deaths: DeathsData?
    var day: String = ""
    var time: String = ""
    
    public enum CodingKeys: String, CodingKey {
        case country = "country"
        case cases = "cases"
        case deaths = "deaths"
        case day = "day"
        case time = "time"
    }
}

internal struct CasesData: Codable {
    var new: String? = ""
    var active: Int = 0
    var critical: Int = 0
    var recovered: Int = 0
    var total: Int = 0
    
    public enum CodingKeys: String, CodingKey {
        case new = "new"
        case active = "active"
        case critical = "critical"
        case recovered = "recovered"
        case total = "total"
    }
}

internal struct DeathsData: Codable {
    var new: String? = ""
    var total: Int = 0
    
    public enum CodingKeys: String, CodingKey {
        case new = "new"
        case total = "total"
    }
}
