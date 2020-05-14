//
//  CountryListDataService.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/6/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

internal class CountryListDataService {
    
    func fetchCountryList(completion: @escaping ((Result<CountryResponse>)-> Void)) {
        
        let resource = Resource(url: "https://covid-193.p.rapidapi.com/countries", method: .GET)
        
        APIClient.shared.load(resource) { (result) in
            switch result {
            case .success(let data):
                                
                do {
                    /*let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)*/
                    let country = try JSONDecoder().decode(CountryResponse.self, from: data)
                    completion(.success(country))
                } catch {
                    print("Error al Decodear la data: ", error.localizedDescription)
                    completion(.failure(error))
                }
        
            case .failure(let error):
                print("Fallo el servicio: ", error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
    func fetchInfectedFeature(completion: @escaping ((Result<FeatureResponse>)-> Void)) {
        
        let resource = Resource(url: "https://covid19-data.p.rapidapi.com/geojson-ww", method: .GET, newHost: "covid19-data.p.rapidapi.com")
        
        APIClient.shared.load(resource) { (result) in
            switch result {
            case .success(let data):
                                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                    let feature = try JSONDecoder().decode(FeatureResponse.self, from: data)
                    completion(.success(feature))
                } catch {
                    print("Error al Decodear la data: ", error.localizedDescription)
                    completion(.failure(error))
                }
        
            case .failure(let error):
                print("Fallo el servicio: ", error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
}
