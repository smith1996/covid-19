//
//  ViewController+Extension.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/7/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func setupTableView(tableView: UITableView, header nameHeader: String? = nil, cell nameCell: String) {
            
        if let header = nameHeader {
            tableView.register(UINib(nibName: header, bundle: nil),
                                forHeaderFooterViewReuseIdentifier: header)
        }
        
        tableView.register(UINib(nibName: nameCell, bundle: nil),
                                   forCellReuseIdentifier: nameCell)
                        
        tableView.allowsSelection = (nameCell == "SummaryCell" ? true : false)
        tableView.reloadData()
    }
    
}
