//
//  CovidDashboardViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidDashboardViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var dashboardTableView: UITableView!
    
    // MARK: Properties
    private var viewModel: CovidDashboardViewModel?
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind(to: CovidDashboardViewModel())
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch Data
        viewModel?.fetchData(false)
    }
    
    // MARK: - Setup
    private func setupTableView() {
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.estimatedRowHeight = 60.0
        dashboardTableView.tableFooterView = UIView()
        dashboardTableView.showsVerticalScrollIndicator = false
        dashboardTableView.showsVerticalScrollIndicator = false
        dashboardTableView.addSubview(refreshControl)
        dashboardTableView.register(UINib(nibName: CovidDashboardCell.className, bundle: .main), forCellReuseIdentifier: CovidDashboardCell.className)
        dashboardTableView.register(UINib(nibName: CovidDashboardCollectionHolderCell.className, bundle: .main), forCellReuseIdentifier: CovidDashboardCollectionHolderCell.className)
    }
    
    private func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = viewModel?.searchbarPlaceholder
        search.searchBar.delegate = self
        navigationItem.searchController = search
    }
    
    // MARK: - Fetch
    @objc
    private func fetch() {
        // Fetch Data
        viewModel?.fetchData(true)
    }
}
// MARK: - Search Mechanism
extension CovidDashboardViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            viewModel?.filterResult(by: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.resetFilter()
    }
}

// MARK: - UITableViewDelegate & UITableViewDatasource
extension CovidDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = viewModel?.sectionType(at: indexPath)
        switch sectionType {
        case .some(.all):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidDashboardCollectionHolderCell.className, for: indexPath) as? CovidDashboardCollectionHolderCell,
                let vm = viewModel?.cellViewModel(at: indexPath) else {
                return UITableViewCell()
            }
            cell.bind(to: vm)
            return cell
        case .some(.country):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidDashboardCell.className, for: indexPath) as? CovidDashboardCell,
                let vm = viewModel?.cellViewModel(at: indexPath) else {
                return UITableViewCell()
            }
            cell.bind(to: vm)
            return cell
        case .none: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = CovidDashboardHeaderView.fromNib() else {
            return nil
        }
        headerView.titleLabel.text = viewModel?.headerText(at: section)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Binding
extension CovidDashboardViewController: CovidBindable {
    typealias T = CovidDashboardViewModel
    
    func bind(to model: CovidDashboardViewModel) {
        self.viewModel = model
        
        self.viewModel?.observe(for: self.viewModel?.response, with: { [weak self] (response) in
            DispatchQueue.main.async {
                if let error = response.result {
                    let action = UIAlertAction(title: self?.viewModel?.retryTitle, style: .default) { (_) in
                        self?.viewModel?.fetchData(false)
                    }
                    self?.showAlert(with: self?.viewModel?.errorTitle, description: error.localizedDescription, type: .alert, actions: [action])
                } else {
                    self?.dashboardTableView.reloadData()
                }
            }
        })
        
        self.viewModel?.observe(for: self.viewModel?.showLoader, with: { [weak self] (shouldShow) in
            DispatchQueue.main.async {
                if shouldShow {
                    self?.show()
                } else {
                    self?.dismiss()
                    if self?.refreshControl.isRefreshing == true {
                        self?.refreshControl.endRefreshing()
                    }
                }
            }
        })
    }
}
