//
//  CovidDashboardHeaderView.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 15/03/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDashboardHeaderView: UIView, NibInstantiatable {

    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout).bold()
    }
}
