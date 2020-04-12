//
//  CovidCountryTableViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class CovidCountryTableViewController: UITableViewController {

    // MARK: Properties
    private var viewModel: CovidCountryListViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        isModalInPresentation = true
        overrideUserInterfaceStyle = .dark
        navigationController?.overrideUserInterfaceStyle = .dark
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: CovidCountryCell.className, bundle: .main), forCellReuseIdentifier: CovidCountryCell.className)
        title = viewModel?.navigationBarTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchBar()
        setupNavigationItem()
    }
    
    // MARK: - Setup
    private func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = viewModel?.searchbarPlaceholder
        search.searchBar.delegate = self
        navigationItem.searchController = search
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
    }
    
    // MARK: - Actions
    @objc
    private func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidCountryCell.className, for: indexPath) as? CovidCountryCell else {
            return UITableViewCell()
        }
        
        if let item = viewModel?.details(at: indexPath) {
            cell.countryNameLabel.text = item.name
            if let image = item.image {
                cell.countryImageView.image = image
            } else {
                cell.countryImageView.image = #imageLiteral(resourceName: "notAvailable")
                cell.countryImageView.tintColor = .label
            }
            cell.accessoryType = item.isSelected ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if navigationItem.searchController?.isActive == true {
            navigationItem.searchController?.isActive = false
            navigationItem.searchController?.dismiss(animated: true, completion: { [weak self] in
                self?.viewModel?.didSelect(at: indexPath)
                self?.dismiss(animated: true, completion: nil)
            })
        } else {
            viewModel?.didSelect(at: indexPath)
            dismiss(animated: true, completion: nil)
        }
    }
}
// MARK: - Search Mechanism
extension CovidCountryTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
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
// MARK: - Binding
extension CovidCountryTableViewController: CovidBindable {
    typealias T = CovidCountryListViewModel
    
    func bind(to model: CovidCountryListViewModel) {
        self.viewModel = model
        self.viewModel?.observe(for: self.viewModel?.shouldReload, with: { [weak self] (_) in
            self?.tableView.reloadData()
        })
    }
}
