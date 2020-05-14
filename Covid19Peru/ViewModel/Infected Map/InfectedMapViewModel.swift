//
//  InfectedMapViewModel.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/27/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

/*protocol InfectedMapView {
    func getInfectedFeature()
    func getData(at indexPath: IndexPath) -> FeatureCountryData
    func filterByName(by string: String) -> [FeatureCountryData]
    //
    var listOfCountryFeature: [FeatureCountryData] { get set }
    var filteredList: [FeatureCountryData] { get set }
}*/

class InfectedMapViewModel { //InfectedMapView
    
    /*typealias T = String
    
    // MARK: - CLosure
    public var reloadTableViewClosure: (() -> ())?
    public var updateLoadingStatusClosure: (() -> ())?
    //
    */
    private let service: InfectedMapDataService
    
    init(service: InfectedMapDataService = InfectedMapDataService()) {
        self.service = service
    }
    
    var listOfCountryFeature: [FeatureCountryData] = [FeatureCountryData]()
    
    var filteredList: [FeatureCountryData] = [FeatureCountryData]()
    
    /*public var isLoading: Bool = false {
        didSet {
            updateLoadingStatusClosure?()
        }
    }
    
    var numberOfItems: Int {
        return genericList.count
    }
    
    var numberOfFilteredItems: Int {
        return filteredList.count
    }
    */

    func getInfectedFeature() {
        
        service.fetchInfectedFeature { [weak self] result in
            switch result {
            case .success(let item):
                guard let feature = self else { return }
                
                guard let list = item.listOfFeatures, list.count != 0 else {
                    //Closure de Empty
                    return
                }
                feature.listOfCountryFeature = list
            case .failure(let error):
                //guard let infected = self else { return }
                //infected.errorServiceClosure?(error.localizedDescription)
                print("Error de Servicio: ", error.localizedDescription)
            }
        }
    }
    
    func getData(at indexPath: IndexPath) -> FeatureCountryData {
        return listOfCountryFeature[indexPath.row]
    }
    
    func filterByName(by string: String) -> [FeatureCountryData] {
        return listOfCountryFeature.filter { (item) -> Bool in
            guard let properties = item.properties else { return false }
            return properties.name.range(of: string, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
    
    func filterMorePrecise(by string: String) -> FeatureCountryData? {
        
        if filteredList.isEmpty { filteredList = listOfCountryFeature }

        let filtered = filteredList.filter { (item) -> Bool in
            guard let properties = item.properties else { return false }
            return properties.name.range(of: string, options: .anchored, range: nil, locale: nil) != nil
        }
        
        guard filtered.count != 0 else {
            return nil
        }
        
        return filtered.first
    }
        
}
