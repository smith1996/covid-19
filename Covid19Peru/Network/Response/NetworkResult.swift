//
//  NetworkResult.swift
//  PruebaYOY
//
//  Created by Smith Huamani Hilario on 1/16/20.
//  Copyright © 2020 YOY. All rights reserved.
//

import Foundation

internal enum Result<T> {//NetworkResponse
    case success(T)
    case failure(Error)//Error
}
