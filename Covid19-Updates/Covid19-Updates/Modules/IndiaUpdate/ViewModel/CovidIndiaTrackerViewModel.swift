//
//  CovidIndiaTrackerViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 19/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation

enum CovidIndiaTrackerTableSection: String, CaseIterable {
    case summary = "Summary"
    case stateList = "State wise Update"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class CovidIndiaTrackerViewModel: NSObject {
    // MARK: Properties
    private (set) var isLoading: Observable<Bool> = Observable(false)
    private (set) var response: Observable<(isSuccess: Bool, error: NetworkError?)> = Observable()
    private var indiaTrackerData: CovidIndiaTracker?
    private let fetcher = CovidIndiaDataFetcher()
    private let sections = CovidIndiaTrackerTableSection.allCases
    private var summaryCellViewModel: DashboardCellCommonModelable?
    private var originalStateUpdatesCellViewModels: [DashboardCellCommonModelable] = []
    private var filteredStateUpdatesCellViewModels: [DashboardCellCommonModelable] = []

    var loaderText: String {
        return NSLocalizedString("Fetching Latest Updates", comment: "")
    }
    var retryTitle: String {
        return GeneralConstants.ReusableText.error.localized()
    }
    
    var errorTitle: String {
        return GeneralConstants.ReusableText.retry.localized()
    }
    
    var navigationTitle: String {
        return NSLocalizedString("Covid-19 India", comment: "")
    }
    
    var noDataFoundText: String {
        return filteredStateUpdatesCellViewModels.isEmpty ? NSLocalizedString("No Data found", comment: "") : ""
    }
    
    var searchbarPlaceholder: String {
        return NSLocalizedString("Try searching using state names", comment: "")
    }
    
    var courtesyText: String {
        return "Data Courtesy: https://github.com/amodm/api-covid19-in"
    }
    
    // MARK: - Fetch Data
    func fetchIndiaData() {
        isLoading.value = true
        fetcher.getIndiaCases { [weak self] (data, error) in
            self?.isLoading.value = false
            if let error = error {
                self?.response.value = (isSuccess: false, error: error)
            } else if let data = data as? CovidIndiaTracker {
                self?.indiaTrackerData = data
                self?.setupSummaryCellViewModel()
                self?.setupStateListCellViewModel()
            } else {
                self?.response.value = (isSuccess: false, error: .clientError)
            }
        }
    }
    
    // MARK: - Setup Cell ViewModels
    private func setupSummaryCellViewModel() {
        if let summary = indiaTrackerData?.data?.summary {
            summaryCellViewModel = CovidIndiaCollectionTableViewCellViewModel(with: summary, lastUpdatedDate: indiaTrackerData?.lastRefreshDate)
        }
    }
    
    private func setupStateListCellViewModel() {
        var cellVMs: [DashboardCellCommonModelable] = []
        let stateData = (indiaTrackerData?.data?.regionalUpdates ?? []).sorted(by: { $0.totalCases ?? Int64(0) > $1.totalCases ?? Int64(0) })
        for stateUpdate in stateData {
            let stateCellViewModel = CovidIndiaStateCellViewModel(locationName: stateUpdate.locationName ?? "", casesCount: stateUpdate.totalCases == nil ? "" : "\(stateUpdate.totalCases!)", fatalityCount: stateUpdate.totalDeaths == nil ? "" : "\(stateUpdate.totalDeaths!)", recoveredCount: stateUpdate.totalRecovered == nil ? "" : "\(stateUpdate.totalRecovered!)", infectedIndiansCount: stateUpdate.confirmedInfectedIndians == nil ? "" : "\(stateUpdate.confirmedInfectedIndians!)", infectedForeignersCount: stateUpdate.confirmedInfectedForeigners == nil ? "" : "\(stateUpdate.confirmedInfectedForeigners!)")
            cellVMs.append(stateCellViewModel)
        }
        
        originalStateUpdatesCellViewModels = cellVMs
        filteredStateUpdatesCellViewModels = cellVMs
        response.value = (isSuccess: true, error: nil)
    }
    
    // MARK: - Datasource
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        if sections.count > section {
            let section = sections[section]
            return section == .some(.summary) ? 1 : filteredStateUpdatesCellViewModels.count
        }
        return 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> DashboardCellCommonModelable? {
        if sections.count > indexPath.section {
            let section = sections[indexPath.section]
            switch section {
            case .summary: return summaryCellViewModel
            case .stateList:
                if filteredStateUpdatesCellViewModels.count > indexPath.row {
                    let cellVM = filteredStateUpdatesCellViewModels[indexPath.row]
                    return cellVM
                }
            }
        }
        return nil
    }
    
    func headerText(at section: Int) -> String? {
        if sections.count > section {
            let section = sections[section]
            return section.localized()
        }
        return nil
    }
    
    func sectionType(at indexPath: IndexPath) -> CovidIndiaTrackerTableSection? {
        if sections.count > indexPath.section {
            let section = sections[indexPath.section]
            return section
        }
        return nil
    }
    
    // MARK: - Filter
    func filterResult(by searchQuery: String) {
        let filtered = (originalStateUpdatesCellViewModels as? [CovidIndiaStateCellViewModel])?.filter({ $0.locationName.lowercased().contains(searchQuery.lowercased()) })
        filteredStateUpdatesCellViewModels = filtered ?? []
        response.value = (isSuccess: true, error: nil)
    }
    
    func resetFilter() {
        filteredStateUpdatesCellViewModels = originalStateUpdatesCellViewModels
        response.value = (isSuccess: true, error: nil)
    }
}
