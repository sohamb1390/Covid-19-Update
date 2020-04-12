//
//  CovidDashboardViewModel.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 05/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

enum CovidDashboardSection: String, CaseIterable {
    case all = "Total cases Worldwide"
    case country = "Country wise Cases"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

final class CovidDashboardViewModel: NSObject {
    // MARK: Properties
    private (set) var showLoader: Observable<Bool> = Observable(false)
    private var allCases: Covid19Cases?
    private var coutntryWiseCases: [Covid19Cases] = []
    private (set) var response: Observable<(result: NetworkError?, isSuccess: Bool)> = Observable()
    private let fetcher = CoovidDashboardFetcher()
    private let sections = CovidDashboardSection.allCases
    private var collectionViewCellViewModel: CovidDashboardCollectionHolderCellViewModel?
    private var originalCountryDataCellViewModels: [CovidDashboardCellViewModel] = []
    private var filteredCountryDataCellViewModels: [CovidDashboardCellViewModel] = []

    var retryTitle: String {
        return NSLocalizedString("RETRY", comment: "")
    }
    
    var errorTitle: String {
        return NSLocalizedString("ERROR", comment: "")
    }
    
    var searchbarPlaceholder: String {
        return NSLocalizedString("Try searching using Country names", comment: "")
    }
    
    var navigationTitle: String {
        return NSLocalizedString("Global Covid-19", comment: "")
    }
    
    var dashboardTabBarTitle: String {
        return NSLocalizedString("Dashboard", comment: "")
    }
    
    var mapTabBarTitle: String {
        return NSLocalizedString("Map", comment: "")
    }
    
    var chartTabBarTitle: String {
        return NSLocalizedString("Chart", comment: "")
    }
    
    static var imageFolderPath: URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentsDirectory = paths.first else {
            return nil
        }
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("FlagIcons")
        return dataPath
    }
    
    override init() {
        super.init()
        createIconsFolder()
    }
    
    // MARK: - Fetch Data
    func fetchData() {
        showLoader.value = true
        originalCountryDataCellViewModels.removeAll()
        filteredCountryDataCellViewModels.removeAll()
        
        // First fetch all cases
        fetcher.getTotalCases { [weak self] (allCases, error) in
            if let data = allCases as? Covid19Cases {
                self?.allCases = data
                self?.setupCollectionViewCellViewModel()
            }
            self?.fetchCountryData()
        }
    }
    
    private func fetchCountryData() {
        fetcher.getCountryWiseData { [weak self] (countryCases, error) in
            self?.showLoader.value = false
            
            if let error = error {
                self?.response.value = (result: error, isSuccess: false)
            } else {
                if let countryData = countryCases as? [Covid19Cases] {
                    self?.coutntryWiseCases = countryData.sorted(by: { ($0.cases ?? Int64(0)) > ($1.cases ?? Int64(0)) })
                    CovidSharedData.shared.countryWiseCases = countryData
                    // Download the flag icons
                    self?.downloadFlagIcons(from: countryData, onCompletion: {
                        // Download John Hopkins Data
                        self?.fetchJohnHopkinsCountryWiseData {
                            self?.setupCountryWiseCellViewModel()
                            return
                        }
                    })
                } else {
                    self?.response.value = (result: error, isSuccess: false)
                }
            }
        }
    }
    
    private func fetchJohnHopkinsCountryWiseData(_ onCompletion: @escaping (() -> Void)) {
        fetcher.getJohnHopkinsCountryWiseData { [weak self] (countryCases, error) in
            self?.showLoader.value = false
            
            if let error = error {
                DPrint("Error downloading john hopkins data: \(error.localizedDescription)")
                onCompletion()
                return
            } else {
                if let countryData = countryCases as? [CovidJohnHopkinsData] {
                    CovidSharedData.shared.johnHopkinsCountryWiseCase = countryData
                    onCompletion()
                    return
                }
            }
            onCompletion()
        }
    }
    
    private func downloadFlagIcons(from countryCases: [Covid19Cases], onCompletion: @escaping (() -> Void)) {
        for (index, item) in countryCases.enumerated() {
            if let countryURL = item.countryInfo?.flagURL {
                fetcher.downloadFlagIcon(from: countryURL) { [weak self] (data, error) in
                    if let data = data, let image = UIImage(data: data) {
                        self?.saveIconFile(image, name: item.country ?? "")
                    }
                }
            }
            if index == countryCases.endIndex - 1 {
                onCompletion()
            }
        }
    }
    
    private func createIconsFolder() {
        if let dataPath = CovidDashboardViewModel.imageFolderPath, !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                DPrint(error.localizedDescription);
            }
        }
    }
    
    private func saveIconFile(_ image: UIImage, name: String) {
        if let dataPath = CovidDashboardViewModel.imageFolderPath {
            let filepath = "\(dataPath.path)/\(name).png"
            let url = URL(fileURLWithPath: filepath)
            do {
                try image.pngData()?.write(to: url)
            } catch {
                DPrint(error.localizedDescription)
            }
        } else {
            DPrint("Image Folder Path is missing")
        }
    }
    
    private func setupCollectionViewCellViewModel() {
        if let data = allCases {
            collectionViewCellViewModel = CovidDashboardCollectionHolderCellViewModel(with: data)
        }
    }
    
    private func setupCountryWiseCellViewModel() {
        if !coutntryWiseCases.isEmpty {
            for countryData in coutntryWiseCases {
                if let countryName = countryData.country {
                    let caseNumber = countryData.cases ?? Int64(0.0)
                    let vm = CovidDashboardCellViewModel(title: countryName, subtitle: "\(caseNumber)")
                    originalCountryDataCellViewModels.append(vm)
                    filteredCountryDataCellViewModels.append(vm)
                }
            }
        }
        response.value = (result: nil, isSuccess: true)
    }
    
    // MARK: - Datasource
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        if sections.count > section {
            let section = sections[section]
            switch section {
            case .all: return allCases == nil ? 0 : 1
            case .country: return filteredCountryDataCellViewModels.count
            }
        }
        return 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> DashboardCellCommonModelable? {
        if sections.count > indexPath.section {
            let section = sections[indexPath.section]
            switch section {
            case .all: return collectionViewCellViewModel
            case .country:
                if filteredCountryDataCellViewModels.count > indexPath.row {
                    let vm = filteredCountryDataCellViewModels[indexPath.row]
                    return vm
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
    
    func sectionType(at indexPath: IndexPath) -> CovidDashboardSection? {
        if sections.count > indexPath.section {
            let section = sections[indexPath.section]
            return section
        }
        return nil
    }
    
    func countryCellViewModel(at indexPath: IndexPath) -> CovidDashboardCollectionHolderCellViewModel? {
        if sections.count > indexPath.section {
            let section = sections[indexPath.section]
            switch section {
            case .all: return nil
            case .country:
                if filteredCountryDataCellViewModels.count > indexPath.row {
                    let vm = filteredCountryDataCellViewModels[indexPath.row]
                    if let data = coutntryWiseCases.filter({ $0.country == vm.title }).first {
                        let countryDetailsVM = CovidDashboardCollectionHolderCellViewModel(with: data)
                        return countryDetailsVM
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Filter
    func filterResult(by searchQuery: String) {
        let filtered = originalCountryDataCellViewModels.filter({ $0.title.lowercased().contains(searchQuery.lowercased()) })
        filteredCountryDataCellViewModels = filtered
        response.value = (result: nil, isSuccess: true)
    }
    
    func resetFilter() {
        filteredCountryDataCellViewModels = originalCountryDataCellViewModels
        response.value = (result: nil, isSuccess: true)
    }
}
