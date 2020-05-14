//
//  InfectedListByCountryDataServices.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/5/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

internal class InfectedListByCountryDataService {
    
    func fetchInfectedListByCountry(country: String, completion: @escaping ((Result<HistoryResponse>)-> Void)) {
        
        let resource = Resource(url: "https://covid-193.p.rapidapi.com/history?country=\(country)", method: .GET)
        
        APIClient.shared.load(resource) { (result) in
            switch result {
            case .success(let data):
                                
                do {
                    /*let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)*/
                    let store = try JSONDecoder().decode(HistoryResponse.self, from: data)
                    completion(.success(store))
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
