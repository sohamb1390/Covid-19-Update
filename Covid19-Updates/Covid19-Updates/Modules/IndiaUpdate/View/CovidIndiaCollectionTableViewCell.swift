//
//  CovidIndiaCollectionTableViewCell.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 18/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidIndiaCollectionTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var updatedDateTitleLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var viewModel: CovidIndiaCollectionTableViewCellViewModel?
    private var myContext = 0
    private var isContentSizeChanged = false
    private let leftAndRightPaddings: CGFloat = 20.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext,
            keyPath == #keyPath(UICollectionView.contentSize) {
            if let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize, contentSize.height > 200.0 {
                heightConstraint.constant = contentSize.height
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.layoutIfNeeded()
                    self.tableView?.beginUpdates()
                    self.tableView?.endUpdates()
                }
            }
        }
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize))
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .vertical
            let bounds = UIScreen.main.bounds
            let width = (bounds.size.width - leftAndRightPaddings*(numberOfItemsPerRow + 2)) / numberOfItemsPerRow
            flowLayout.itemSize = CGSize(width: width, height: width)
        } else {
            assertionFailure("Collection view layout is not flow layout. SelfSizing may not work")
        }
        collectionView.register(UINib(nibName: CovidDashboardCollectionCell.className, bundle: .main), forCellWithReuseIdentifier: CovidDashboardCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: &myContext)
    }
}

// MARK: - Binding
extension CovidIndiaCollectionTableViewCell: CovidBindable {
    typealias T = DashboardCellCommonModelable
    
    func bind(to model: DashboardCellCommonModelable) {
        self.viewModel = model as? CovidIndiaCollectionTableViewCellViewModel
        self.updatedDateTitleLabel.text = self.viewModel?.lastUpdatedAtText ?? ""
        self.updatedDateLabel.text = self.viewModel?.getLastUpdatedDate() ?? ""
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDatasource
extension CovidIndiaCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CovidDashboardCollectionCell.className, for: indexPath) as? CovidDashboardCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let item = viewModel?.item(at: indexPath) {
            cell.bind(to: item)
        }
        return cell
    }
}
