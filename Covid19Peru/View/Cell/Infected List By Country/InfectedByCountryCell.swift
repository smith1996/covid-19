//
//  InfectedByCountryCell.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/4/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

class InfectedByCountryCell: UITableViewCell {
    
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var activeCasesAmountLabel: UILabel!
    @IBOutlet weak var recoveredCasesAmountLabel: UILabel!
    @IBOutlet weak var deathsAmountLabel: UILabel!
    
    public var infectedByCountry: InfectedCountryData = InfectedCountryData() {
        didSet {
            
            if let value = infectedByCountry.cases {
                totalAmountLabel.text = value.total.withCommas()
                activeCasesAmountLabel.text = value.active.withCommas()
                recoveredCasesAmountLabel.text = value.recovered.withCommas()
            }
            
            if let value = infectedByCountry.deaths {
                deathsAmountLabel.text = value.total.withCommas()
            }
            
            let date = infectedByCountry.time.dateFormatter
            let dateSeparator = date.components(separatedBy: " ")
            
            dateLabel.text = "🗓 \(dateSeparator[0])"
            timeLabel.text = "⏰ \(dateSeparator[1]) \(dateSeparator[2])"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainBackground.addShadowViewCustom(cornerRadius: 10.0)
        //contentView.autoresizingMask = .flexibleHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
