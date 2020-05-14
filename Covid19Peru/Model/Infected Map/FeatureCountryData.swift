//
//  FeatureCountryData.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/27/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

internal struct FeatureCountryData: Codable {
    
    var type: String
    var properties: PropertiesData?
    var geometry: GeometryData?
    
    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case properties = "properties"
        case geometry = "geometry"
    }
    
    init() {
        self.type = ""
        self.properties = nil//PropertiesData()
        self.geometry = nil//GeometryData()
    }
}

internal struct PropertiesData: Codable {
        
    var name: String
    var continent: String
    var latitude: String
    var longitude: String
    var confirmed: StringOrInt
    var deaths: StringOrInt
    var active: StringOrInt
    var recovered: StringOrInt
        
    public enum CodingKeys: String, CodingKey {
        case name = "name"
        case continent = "continent"
        case latitude = "latitude"
        case longitude = "longitude"
        case confirmed = "confirmed"
        case deaths = "deaths"
        case active = "active"
        case recovered = "recovered"
    }
    
}

internal struct GeometryData: Codable {
    
    var type: String    
    let coordinates: [[[[Double]]]]?
    
    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        
        if let arrays = try? container.decode([[[Double]]].self, forKey: .coordinates) {
            coordinates = [arrays]
        } else {
            coordinates = try container.decode([[[[Double]]]].self, forKey: .coordinates)
        }
    }
    
}

enum StringOrInt: Codable {
    
    case string(String), integer(Int)
        
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let stringValue = try container.decode(String.self)
            self = .string(stringValue)
        } catch DecodingError.typeMismatch {
            let integerValue = try container.decode(Int.self)
            self = .integer(integerValue)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue): try container.encode(stringValue)
        case .integer(let integerValue): try container.encode(integerValue)
        }
    }
}
