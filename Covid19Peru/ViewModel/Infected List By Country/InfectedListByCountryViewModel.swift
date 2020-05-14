//
//  InfectedListByCountryViewModel.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/5/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

class InfectedListByCountryViewModel {
    
    // MARK: - Clousure
    public var reloadTableViewClosure: (() -> ())?
    public var updateLoadingStatusClosure: (() -> ())?
    //public var errorServiceClosure: ((String) -> ())?
    //
    
    private let service: InfectedListByCountryDataService
    
    init(service: InfectedListByCountryDataService = InfectedListByCountryDataService()) {
        self.service = service
    }
    
    fileprivate var listOfInfectedByCountry: [InfectedCountryData] = [InfectedCountryData]() {
        didSet {
            self.getCurrentList(tableView: nil)
            //self.getHistorialList(tableView: nil)
        }
    }
    
    var listOfHistory: [InfectedCountryData] = [InfectedCountryData]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatusClosure?()
        }
    }
    
    var numberOfItems: Int {
        return listOfHistory.count
    }
    
    func getInfectedHistoryByCountry(country name: String) {
        
        isLoading = true
        service.fetchInfectedListByCountry(country: name) { [weak self] result in
            
            switch result {
            case .success(let item):
                guard let infected = self else { return }
                
                guard let list = item.listOfIntectedCountry, list.count != 0 else {
                    //Closure de Empty
                    return
                }
                infected.listOfInfectedByCountry = list
                //infected.listOfCurrentInfected = [list.first ?? InfectedCountryData()]
                infected.isLoading = false
            case .failure(let error):
                guard let infected = self else { return }
                //infected.errorServiceClosure?(error.localizedDescription)
                print("Error de Servicio: ", error.localizedDescription)
                infected.isLoading = false
            }
        }
    }
    
    func getData(at indexPath: IndexPath) -> InfectedCountryData {
        return listOfHistory[indexPath.row]
    }
    
    final func getHistorialList(tableView: UITableView?) {
        
        guard let `tableView` = tableView else {
            listOfHistory = listOfInfectedByCountry
            return
        }        
        for index in 0..<listOfInfectedByCountry.count {
            if index > 0 {
                let newItem = listOfInfectedByCountry[index]
                listOfHistory.append(newItem)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    final func getCurrentList(tableView: UITableView?) {
        
        guard let `tableView` = tableView else {
            listOfHistory = [listOfInfectedByCountry.first ?? InfectedCountryData()]
            return
        }

        for index in (0..<listOfInfectedByCountry.count).reversed() {
            if index > 0 {
                listOfHistory.remove(at: index)
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                tableView.endUpdates()
            }

        }
        
    }
    
}
