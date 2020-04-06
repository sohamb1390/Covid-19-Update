//
//  CovidDashboardCollectionCell.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 06/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDashboardCollectionCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: ShadowView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateFontStyle()
        updateTextColor()
        setupUI()
    }

    private func updateFontStyle() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout).bold()
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
    }
    
    private func updateTextColor() {
        titleLabel.textColor = UIColor(named: "Text") ?? UIColor(appColor: .text)
        subtitleLabel.textColor = UIColor(appColor: .red)
    }
    
    private func setupUI() {
        if traitCollection.userInterfaceStyle == .dark {
            containerView.shadowColor = .clear
        }
    }
}

// MARK: - Binding
extension CovidDashboardCollectionCell: CovidBindable {
    typealias T = CovidDashboardCellViewModel
    
    func bind(to model: CovidDashboardCellViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
