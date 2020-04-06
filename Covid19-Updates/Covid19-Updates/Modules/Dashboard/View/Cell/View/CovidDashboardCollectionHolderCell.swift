//
//  CovidDashboardCollectionHolderCell.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 06/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDashboardCollectionHolderCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: CovidDashboardCollectionHolderCellViewModel?
    private var myContext = 0
    var isContentSizeChanged = false
    
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
            // let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize
            if !isContentSizeChanged {
                isContentSizeChanged = true
                tableView?.beginUpdates()
                tableView?.endUpdates()
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
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 150.0, height: 150.0)
            flowLayout.minimumLineSpacing = 20.0
            flowLayout.minimumInteritemSpacing = 20.0
        } else {
            assertionFailure("Collection view layout is not flow layout. SelfSizing may not work")
        }
        collectionView.register(UINib(nibName: CovidDashboardCollectionCell.className, bundle: .main), forCellWithReuseIdentifier: CovidDashboardCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: &myContext)
    }
}

// MARK: - Binding
extension CovidDashboardCollectionHolderCell: CovidBindable {
    typealias T = DashboardCellCommonModelable
    
    func bind(to model: DashboardCellCommonModelable) {
        isContentSizeChanged = false
        self.viewModel = model as? CovidDashboardCollectionHolderCellViewModel
        if let timeStamp = (model as? CovidDashboardCollectionHolderCellViewModel)?.timeStampText {
            self.updatedAtLabel.text = "\((model as? CovidDashboardCollectionHolderCellViewModel)?.lastUpdatedAtText ?? "") \(timeStamp)"
        }
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDatasource
extension CovidDashboardCollectionHolderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CovidDashboardCollectionCell.className, for: indexPath) as? CovidDashboardCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let item = viewModel?.value(at: indexPath) {
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.value
        }
        return cell
    }
}
