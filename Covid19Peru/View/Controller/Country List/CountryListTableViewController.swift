//
//  CountryListTableViewController.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/6/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

struct SelectedCountry {
    var name: String
    var feature: FeatureCountryData?
    
    init() {
        name = ""
        feature = nil
    }
    
    init(name: String, feature: FeatureCountryData?) {
        self.name = name
        self.feature = feature
    }
}

class CountryListTableViewController: UITableViewController {

    /*lazy var mapViewModel: InfectedMapViewModel = {
        return InfectedMapViewModel()
    }()*/
    
    lazy var viewModel: CountryListViewModel = {
        return CountryListViewModel()
    }()
    
    lazy var searchBarController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.placeholder = "Buscar"
        controller.searchBar.delegate = self
        controller.obscuresBackgroundDuringPresentation = false
       return controller
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupSearchController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        initViewModel()
    }
    
    private func setupUI() {
        navigationItem.title = "Covid-19: Países"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        //tableView.tableHeaderView = searchController.searchBar
    }
    
    func initViewModel() {
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                guard let country = self else { return }
                country.tableView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                guard let country = self else { return }
                
                guard country.viewModel.isLoading else {
                    ULoaderManager.shared.removeLoad()
                    return
                }
                ULoaderManager.shared.presentLoad()
            }
        }
        
        viewModel.getCountryList()
        viewModel.getInfectedFeature()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !searchBarController.isActive else {
            return viewModel.numberOfFilteredItems
        }
        return viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = viewModel.getData(at: indexPath).replacingOccurrences(of: "-", with: " ")
        cell.textLabel?.text = name
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row, viewModel.getData(at: indexPath))
        let name = viewModel.getData(at: indexPath)
        let feature = viewModel.filterMorePrecise(by: name.replacingOccurrences(of: "-", with: " "))
        let selectedCountry = SelectedCountry(name: name, feature: feature)
        
        performSegue(withIdentifier: "goInfectedHistory", sender: selectedCountry)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goInfectedHistory":
            let vc = segue.destination as! InfectedListByCountryViewController
            vc.selectedCountry = sender as! SelectedCountry
        default:
            break
        }
    }

}

extension CountryListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchedText = searchController.searchBar.text, !searchedText.isEmpty else {
            //searchBarController.obscuresBackgroundDuringPresentation = true
            return
        }
        //searchBarController.obscuresBackgroundDuringPresentation = false
        
        let filteredList = viewModel.filterByName(by: searchedText)
        viewModel.filteredList = filteredList
        //
        let filtered = viewModel.mapFilterByName(by: searchedText)
        viewModel.mapFilteredList = filtered
    }
    
}

extension CountryListTableViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarController.isActive = false
        viewModel.filteredList = []
        //
        viewModel.mapFilteredList = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
}
