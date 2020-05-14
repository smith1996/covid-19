//
//  CountryListViewModel.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/7/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

protocol GenericMethodsDelegate {
    associatedtype T
    var genericList: [T] { get set }
    var isLoading: Bool { get set }
    var reloadTableViewClosure: (() -> ())? { get }
    var updateLoadingStatusClosure: (() -> ())? { get }
    var numberOfItems: Int { get }
    func getData(at indexPath: IndexPath) -> T
}

protocol InfectedMapView {
    func getInfectedFeature()
    func mapFilterByName(by string: String) -> [FeatureCountryData]
    //
    var listOfCountryFeature: [FeatureCountryData] { get set }
    var mapFilteredList: [FeatureCountryData] { get set }
}


class CountryListViewModel: InfectedMapView, GenericMethodsDelegate {
    
    typealias T = String
    
    // MARK: - CLosure
    public var reloadTableViewClosure: (() -> ())?
    public var updateLoadingStatusClosure: (() -> ())?
    //
    
    private let service: CountryListDataService
    
    init(service: CountryListDataService = CountryListDataService()) {
        self.service = service
    }
    
    public var genericList: [String] = [String]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var filteredList: [String] = [String]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    public var isLoading: Bool = false {
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
    

    func getCountryList() {
        
        isLoading = true
        service.fetchCountryList { [weak self] result in
            
            switch result {
            case .success(let item):
                guard let country = self else { return }
                
                guard let list = item.listOfCountries, list.count != 0 else {
                    //Closure de Empty
                    return
                }
                country.genericList = list
                //country.isLoading = false
            case .failure(let error):
                guard let infected = self else { return }
                //infected.errorServiceClosure?(error.localizedDescription)
                print("Error de Servicio: ", error.localizedDescription)
                infected.isLoading = false
            }
        }
        
    }
    
    func getData(at indexPath: IndexPath) -> String {
        guard filteredList.count == 0 else {
            return filteredList[indexPath.row]
        }
        return genericList[indexPath.row]
    }
    
    func filterByName(by string: String) -> [String] {
        return genericList.filter { (item) -> Bool in
            return item.range(of: string, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
    
    // Service Infected Map
    
    var listOfCountryFeature: [FeatureCountryData] = [FeatureCountryData]()
    
    var mapFilteredList: [FeatureCountryData] = [FeatureCountryData]()
    
    func getInfectedFeature() {
        
        isLoading = true
        service.fetchInfectedFeature { [weak self] result in
            switch result {
            case .success(let item):
                guard let feature = self else { return }
                
                guard let list = item.listOfFeatures, list.count != 0 else {
                    //Closure de Empty
                    return
                }
                feature.listOfCountryFeature = list
                feature.isLoading = false
            case .failure(let error):
                guard let feature = self else { return }
                //infected.errorServiceClosure?(error.localizedDescription)
                print("Error de Servicio: ", error.localizedDescription)
                feature.isLoading = false
            }
        }
    }
    
    func mapFilterByName(by string: String) -> [FeatureCountryData] {
        return listOfCountryFeature.filter { (item) -> Bool in
            guard let properties = item.properties else { return false }
            return properties.name.range(of: string, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
    
    func filterMorePrecise(by string: String) -> FeatureCountryData? {
        
        if mapFilteredList.isEmpty { mapFilteredList = listOfCountryFeature }

        let filtered = mapFilteredList.filter { (item) -> Bool in
            guard let properties = item.properties else { return false }
            return properties.name.range(of: string, options: .anchored, range: nil, locale: nil) != nil
        }
        
        guard filtered.count != 0 else {
            return nil
        }
        
        return filtered.first
    }
}
