//
//  CovidPieChartViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 11/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import Charts

class CovidPieChartViewController: CovidChartBaseViewController {

    // MARK: IBOutlets
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var countryNameLabel: UILabel! {
        didSet {
            countryNameLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        }
    }
    
    // MARK: Properties
    private (set) var viewModel: PieChartViewViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .unspecified
        
        bind(to: PieChartViewViewModel(with: CovidSharedData.shared.countryWiseCases))
        setup()
        setup(pieChartView: chartView)
        chartView.delegate = self
        countryNameLabel.text = viewModel?.selectedCountryName.value ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.largeTitleDisplayMode = .never
        
        tabBarController?.navigationController?.navigationBar.prefersLargeTitles = false

        tabBarController?.navigationItem.searchController = nil
        
        tabBarController?.navigationController?.isNavigationBarHidden = false
        
        updateNavigationBarTitle()
        // Fetch Data
        updateChartData()
    }
    
    // MARK: - Update UI
    private func updateNavigationBarTitle() {
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.title = viewModel?.navigationTitle
    }
    
    // MARK: - Setup Chart View
    private func setup() {
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0

        // entry label styling
        chartView.drawEntryLabelsEnabled = true
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = UIFont.preferredFont(forTextStyle: .footnote).bold()
    }
    
    override func updateChartData() {
        guard let entries = viewModel?.setupData(), !entries.isEmpty else {
            return
        }
        
        let set = PieChartDataSet(entries: entries, label: viewModel?.lastUpdatedAtText ?? "")
        set.drawIconsEnabled = true
        set.sliceSpace = 0
        set.colors = [.orange, UIColor(appColor: .red), UIColor(appColor: .green), UIColor(appColor: .base)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont.preferredFont(forTextStyle: .footnote).bold())
        data.setValueTextColor(.label)
        data.highlightEnabled = true
        chartView.data = data
        chartView.highlightValues(nil)
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    // MARK: - Actions
    @IBAction func onTapCountryPicker(_ sender: Any) {
        guard let countryListViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: CovidCountryTableViewController.className) as? CovidCountryTableViewController, let vm = viewModel?.getCountryListViewModel() else {
            return
        }
        countryListViewController.bind(to: vm)
        let nav = UINavigationController(rootViewController: countryListViewController)
        nav.modalPresentationStyle = .formSheet
        tabBarController?.navigationController?.present(nav, animated: true, completion: nil)
    }
}
// MARK: - Binding
extension CovidPieChartViewController: CovidBindable {
    typealias T = PieChartViewViewModel
    func bind(to model: PieChartViewViewModel) {
        self.viewModel = model
        self.viewModel?.observe(for: self.viewModel?.selectedCountryName, with: { [weak self] (name) in
            self?.updateChartData()
            self?.countryNameLabel.text = name
        })
    }
}
