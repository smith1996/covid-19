//
//  NetworkResource.swift
//  PruebaYOY
//
//  Created by Smith Huamani Hilario on 1/16/20.
//  Copyright © 2020 YOY. All rights reserved.
//

import Foundation

internal struct Resource {
    var url: String
    var body: Data?
    var method: Method
    var headers: [String: String]
}

extension Resource {
    
    init(url: String, params: Data? = nil, method: Method, newHost: String = "covid-193.p.rapidapi.com") {
        self.url = url
        self.body = params
        self.method = method
        self.headers = ["Host": "<calculated when request is sent>",
                        "x-rapidapi-host": newHost,//covid19-data.p.rapidapi.com
                        "x-rapidapi-key": "932bf90d22mshb3b4f26c2b4a52dp1ddaedjsn40028c30987b"]
                        //,"Content-Type": "application/json"
    }
    
}

// TODO: - Move to the separated file URLRequest+Resource.swift

extension URLRequest {
    
    init(_ resource: Resource) {

        self.init(url: URL(string: resource.url)!)
        self.httpMethod = resource.method.rawValue
        self.httpBody = resource.body
        self.allHTTPHeaderFields = resource.headers
    }
    
}
