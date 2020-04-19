//
//  CovidIndiaTrackerViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 19/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidIndiaTrackerViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var viewModel: CovidIndiaTrackerViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        bind(to: CovidIndiaTrackerViewModel())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        updateNavigationBarTitle()
        viewModel?.fetchIndiaData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.0
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(UINib(nibName: CovidIndiaCollectionTableViewCell.className, bundle: .main), forCellReuseIdentifier: CovidIndiaCollectionTableViewCell.className)
        tableView.register(UINib(nibName: CovidIndiaStateCell.className, bundle: .main), forCellReuseIdentifier: CovidIndiaStateCell.className)
    }
    
    private func updateNavigationBarTitle() {
        tabBarController?.navigationItem.title = viewModel?.navigationTitle
    }
}
// MARK: - UITableViewDelegate & UITableViewDatasource
extension CovidIndiaTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let vm = viewModel, let sectionType = vm.sectionType(at: indexPath) {
            switch sectionType {
            case .summary:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidIndiaCollectionTableViewCell.className, for: indexPath) as? CovidIndiaCollectionTableViewCell,
                    let cellVM = vm.cellViewModel(at: indexPath) else {
                    return UITableViewCell()
                }
                cell.bind(to: cellVM)
                cell.selectionStyle = .none
                return cell
            case .stateList:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidIndiaStateCell.className, for: indexPath) as? CovidIndiaStateCell,
                    let cellVM = vm.cellViewModel(at: indexPath) else {
                    return UITableViewCell()
                }
                cell.bind(to: cellVM)
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = CovidDashboardHeaderView.fromNib() else {
            return nil
        }
        headerView.titleLabel.text = viewModel?.headerText(at: section)
        return headerView
    }
}

// MARK: - Binding
extension CovidIndiaTrackerViewController: CovidBindable {
    typealias T = CovidIndiaTrackerViewModel
    func bind(to model: CovidIndiaTrackerViewModel) {
        self.viewModel = model
        
        self.viewModel?.observe(for: self.viewModel?.isLoading, with: { [weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    self?.show(with: model.loaderText)
                } else {
                    self?.dismiss()
                }
            }
        })
        
        self.viewModel?.observe(for: self.viewModel?.response, with: { [weak self] (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    let action = UIAlertAction(title: self?.viewModel?.retryTitle, style: .default) { (_) in
                        self?.viewModel?.fetchIndiaData()
                    }
                    self?.showAlert(with: self?.viewModel?.errorTitle, description: error.localizedDescription, type: .alert, actions: [action])
                } else {
                    self?.tableView.reloadData()
                }
            }
        })
    }
}
