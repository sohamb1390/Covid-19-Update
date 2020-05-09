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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .unspecified
        
        bind(to: CovidDashboardViewModel())
        setupTableView()
        setupSearchBar()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        updateNavigationBarTitle()
        setupNavigationItem()
        setupSearchBar()
        // Fetch Data
        viewModel?.fetchData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.estimatedRowHeight = 60.0
        dashboardTableView.tableFooterView = UIView()
        dashboardTableView.showsVerticalScrollIndicator = false
        dashboardTableView.showsVerticalScrollIndicator = false
        dashboardTableView.keyboardDismissMode = .interactive
        dashboardTableView.register(UINib(nibName: CovidDashboardCell.className, bundle: .main), forCellReuseIdentifier: CovidDashboardCell.className)
        dashboardTableView.register(UINib(nibName: CovidDashboardCollectionHolderCell.className, bundle: .main), forCellReuseIdentifier: CovidDashboardCollectionHolderCell.className)
    }
    
    private func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = viewModel?.searchbarPlaceholder
        search.searchBar.delegate = self
        tabBarController?.navigationItem.searchController = search
    }
    
    private func setupNavigationItem() {
        tabBarController?.navigationController?.overrideUserInterfaceStyle = .unspecified
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
        let refreshNavigationItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onTapRefresh(_:)))
        refreshNavigationItem.tintColor = UIColor(appColor: .base)
        refreshNavigationItem.style = .done
        tabBarController?.navigationItem.rightBarButtonItem = refreshNavigationItem
    }
    
    private func setupTabBar() {
        for subViewController in tabBarController?.viewControllers ?? [] {
            if subViewController.isKind(of: CovidDashboardViewController.self) {
                subViewController.tabBarItem.title = viewModel?.dashboardTabBarTitle
            } else if subViewController.isKind(of: CovidDashboardViewController.self) {
                subViewController.tabBarItem.title = viewModel?.mapTabBarTitle
            } else if subViewController.isKind(of: CovidPieChartViewController.self) {
                subViewController.tabBarItem.title = viewModel?.chartTabBarTitle
            } else if subViewController.isKind(of: CovidIndiaTrackerViewController.self) {
                subViewController.tabBarItem.title = viewModel?.indiaTrackerTabBarTitle
            }
        }
        tabBarController?.navigationController?.overrideUserInterfaceStyle = .unspecified
        tabBarController?.overrideUserInterfaceStyle = .unspecified
        tabBarController?.tabBar.tintColor = UIColor(appColor: .base)
    }
    
    private func updateNavigationBarTitle() {
        tabBarController?.navigationItem.title = viewModel?.navigationTitle
    }
    
    // MARK: - Actions
    @objc
    private func onTapRefresh(_ sender: Any) {
        tabBarController?.navigationItem.rightBarButtonItem = nil
        let loader = UIActivityIndicatorView(style: .medium)
        loader.tintColor = UIColor(appColor: .base)
        loader.startAnimating()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loader)
        fetch()
    }
    
    // MARK: - Fetch
    private func fetch() {
        // Fetch Data
        viewModel?.fetchData()
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
        headerView.titleLabel.textColor = UIColor(appColor: .segmentBackground)
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
        if let cellVM = viewModel?.countryCellViewModel(at: indexPath),
            let navigationController = UIViewController.getViewController(ofType: UINavigationController.self, fromStoryboardName: "CovidDetails", storyboardId: "CovidDetailsNavigationController", bundle: .main),
            let detailsViewController = navigationController.viewControllers.first as? CovidDetailsViewController {
            detailsViewController.bind(to: cellVM)
            
            navigationController.modalPresentationStyle = .formSheet
            tabBarController?.navigationController?.present(navigationController, animated: true, completion: nil)
        }
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
                        self?.fetch()
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
                    self?.setupNavigationItem()
                }
            }
        })
    }
}
