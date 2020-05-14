//
//  ViewController.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/4/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

class InfectedListByCountryViewController: UIViewController {
    
    @IBOutlet weak var infectedByCountryTableView: UITableView!
    
    lazy var selectedCountry: SelectedCountry = SelectedCountry()
    
    lazy var viewModel: InfectedListByCountryViewModel = {
        return InfectedListByCountryViewModel()
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let title = ["Actual", "Historial"]
        let segmentControl = UISegmentedControl(items: title)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.autoresizingMask = .flexibleWidth
        segmentControl.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
        segmentControl.addTarget(self, action: #selector(action(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    lazy var infectedMapViewController: InfectedMapViewController = {
        let viewController = InfectedMapViewController(nibName: "InfectedMapViewController", bundle: nil)
        viewController.view.frame = CGRect(x: 0,
                                           y: view.frame.height - Constant.heightForPresentationView,
                                           width: view.bounds.width,
                                           height: view.frame.height - navigationBarHeight)
        viewController.presentationView = view
        viewController.features = selectedCountry.feature
        viewController.view.clipsToBounds = true
        return viewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView(tableView: infectedByCountryTableView, cell: "InfectedByCountryCell")
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleGestureRecognizer(recognizer:)))
        infectedMapViewController.testView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()
    }
    
    private func setupUI() {
        navigationItem.title = "Reporte de \(selectedCountry.name.replacingOccurrences(of: "-", with: " "))"
        navigationItem.titleView = segmentedControl
        infectedByCountryTableView.delegate = self
        infectedByCountryTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Initialization view model
    
    private func initViewModel() {
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                guard let infected = self else { return }
                infected.infectedByCountryTableView.reloadData()
                infected.addInfectedMapBottomSheet()
            }
        }
        
        //
        
        viewModel.updateLoadingStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                guard let infected = self else { return }
                
                if infected.viewModel.isLoading {
                    ULoaderManager.shared.presentLoad()
                    UIView.animate(withDuration: 0.2) {
                        infected.infectedByCountryTableView.alpha = 0.0
                    }
                } else {
                    ULoaderManager.shared.removeLoad()
                    UIView.animate(withDuration: 0.2) {
                        infected.infectedByCountryTableView.alpha = 1.0
                    }
                }
                
            }
        }
        
        //
        viewModel.getInfectedHistoryByCountry(country:selectedCountry.name)
    }
    
    @IBAction func action(_ sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.getCurrentList(tableView: infectedByCountryTableView)
            break
        default:
            viewModel.getHistorialList(tableView: infectedByCountryTableView)
            break
        }
        
        //Swift.debugPrint("CustomTitleViewController IBAction invoked \(segmentedControl.selectedSegmentIndex)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goInfectedMap":
            /*let vc = segue.destination as! InfectedMapViewController
            vc.view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            vc.modalPresentationStyle = .currentContext
            vc.modalTransitionStyle = .coverVertical
            vc.view.frame = CGRect(x: 0, y: vc.view.frame.size.height - 120, width: vc.view.frame.size.width, height: 550)
            self.addChild(vc)
            self.view.addSubview(vc.view)*/
            break
        default:
            break
        }
    }
    
    func addInfectedMapBottomSheet() {
        //infectedMapViewController.features = selectedCountry.feature
        infectedMapViewController.view.addShadowViewCustom(cornerRadius: 20.0)
        addChild(infectedMapViewController)
        view.addSubview(infectedMapViewController.view)
    }
    
    @objc func handleGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        
        guard let bottomSheet = infectedMapViewController.bottomSheet else {
            return
        }
        
        switch recognizer.state {
        case .began:
            bottomSheet.startInteractiveTransition(state: bottomSheet.isVisible ? .collapsed : .expanded , duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: infectedMapViewController.testView)
            var fractionComplete = translation.y / bottomSheet.bottomViewHeight
            fractionComplete = bottomSheet.isVisible ? fractionComplete : -fractionComplete
            bottomSheet.updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            bottomSheet.continueInteractiveTransition()
        default:
            break
        }
        
    }
}

// MARK: - Table view data source

extension InfectedListByCountryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listOfHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfectedByCountryCell", for: indexPath) as? InfectedByCountryCell else {
            fatalError("No existe Cell en Storyboard")
        }
        cell.infectedByCountry = viewModel.getData(at: indexPath)
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        self.viewModel.listOfInfectedByCountry.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }*/
    
}

extension UIViewController {
    
    var navigationBarHeight: CGFloat {
        guard let navController = navigationController else {
            return 0.0
        }
        let titleHeight: CGFloat = 100.0
        return navController.navigationBar.frame.origin.y + titleHeight
    }
    
}
