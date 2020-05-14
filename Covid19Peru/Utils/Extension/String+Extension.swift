//
//  String+Extension.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/18/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

extension String {
    
    public var dateFormatter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "es_PE")
        let formattedDate = formatter.date(from: self)
        formatter.dateFormat = "dd/MM/yyyy HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        //formatter.locale = Locale(identifier: "es_PE")
        return formatter.string(from: formattedDate!)
    }
}
