//
//  ConvidDetailsViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 06/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDetailsViewController: UICollectionViewController {

    // MARK: Properties
    private var viewModel: CovidDashboardCollectionHolderCellViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        overrideUserInterfaceStyle = .unspecified
        navigationController?.overrideUserInterfaceStyle = .unspecified

        title = viewModel?.countryName

        // Setup
        setupCollectionView()
        setupNavigationItem()
        // Do any additional setup after loading the view.
        collectionView.reloadData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: 150.0, height: 150.0)
            flowLayout.minimumLineSpacing = 20.0
            flowLayout.minimumInteritemSpacing = 20.0
        } else {
            assertionFailure("Collection view layout is not flow layout. SelfSizing may not work")
        }
        collectionView.register(UINib(nibName: CovidDashboardCollectionCell.className, bundle: .main), forCellWithReuseIdentifier: CovidDashboardCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.tintColor = UIColor(appColor: .base)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
    }
    
    // MARK: - Actions
    @objc
    private func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
// MARK: - UICollectionViewFlowLayout
extension CovidDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
        }
        return .zero
    }
}
// MARK: - Binding
extension CovidDetailsViewController: CovidBindable {
    typealias T = CovidDashboardCollectionHolderCellViewModel
    
    func bind(to model: CovidDashboardCollectionHolderCellViewModel) {
        self.viewModel = model
    }
}
