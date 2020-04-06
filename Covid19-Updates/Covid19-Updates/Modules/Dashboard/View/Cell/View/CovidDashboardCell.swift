//
//  CovidDashboardCell.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDashboardCell: UITableViewCell {

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Binding
extension CovidDashboardCell: CovidBindable {
    typealias T = DashboardCellCommonModelable
    
    func bind(to model: DashboardCellCommonModelable) {
        let vm = model as? CovidDashboardCellViewModel
        textLabel?.text = vm?.title
        detailTextLabel?.text = vm?.subtitle
    }
}
