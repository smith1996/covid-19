//
//  NetworkError.swift
//  PruebaYOY
//
//  Created by Smith Huamani Hilario on 1/16/20.
//  Copyright © 2020 YOY. All rights reserved.
//

import Foundation

internal enum APIClientError: Error {//NetworkError
    case noData
    case invalidAuthentication
    case requestTimedout
    case badRequest

//    var localizedDescription: String {
//        switch self {
//        case .noData:
//            return Localizable.Global.emptyList.localized
//        case .invalidAuthentication:
//            return "El usuario y contresaña son incorrectas"
//        case .requestTimedout:
//            return Localizable.Global.serviceError.localized
//        case .badRequest:
//            return "Error en el sistema: Specified argument was out of the range of valid values."
//        }
//    }
    
}
