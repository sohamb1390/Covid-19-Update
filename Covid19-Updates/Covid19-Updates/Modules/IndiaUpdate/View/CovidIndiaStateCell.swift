//
//  CovidIndiaStateCell.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 19/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidIndiaStateCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var confirmedCaseCountLabel: UILabel!
    @IBOutlet weak var caseCountTitleLabel: UILabel!
    @IBOutlet weak var confirmedRecoveredCountLabel: UILabel!
    @IBOutlet weak var recoveredCountTitleLabel: UILabel!
    @IBOutlet weak var confirmedFatalityCountLabel: UILabel!
    @IBOutlet weak var fatalityTitleLabel: UILabel!
    @IBOutlet weak var confirmedIndianCaseCountLabel: UILabel!
    @IBOutlet weak var indianCountTitleLabel: UILabel!
    @IBOutlet weak var confirmedForeignerCaseCountLabel: UILabel!
    @IBOutlet weak var foreignerCountTitleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UI Setup
}

// MARK: - Binding
extension CovidIndiaStateCell: CovidBindable {
    typealias T = DashboardCellCommonModelable
    func bind(to model: DashboardCellCommonModelable) {
        guard let vm = model as? CovidIndiaStateCellViewModel else {
            return
        }
        locationNameLabel.text = vm.locationName.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.locationName
        confirmedCaseCountLabel.text = vm.casesCount.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.casesCount
        caseCountTitleLabel.text = vm.casesCountTitle
        confirmedRecoveredCountLabel.text = vm.recoveredCount.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.recoveredCount
        recoveredCountTitleLabel.text = vm.recoveredTitle
        confirmedFatalityCountLabel.text = vm.fatalityCount.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.fatalityCount
        fatalityTitleLabel.text = vm.fatalityTitle
        confirmedIndianCaseCountLabel.text = vm.infectedIndiansCount.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.infectedIndiansCount
        indianCountTitleLabel.text = vm.infectedIndiansCountTitle
        confirmedForeignerCaseCountLabel.text = vm.infectedForeignersCount.isEmpty ? GeneralConstants.ReusableText.notAvailableString.localized() : vm.infectedForeignersCount
        foreignerCountTitleLabel.text = vm.infectedForeignersCountTitle
    }
}
