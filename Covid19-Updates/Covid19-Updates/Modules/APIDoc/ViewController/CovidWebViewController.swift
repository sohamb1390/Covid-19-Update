//
//  CovidWebViewController.swift
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 13/04/20.
//  Copyright © 2020 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import WebKit

class CovidWebViewController: UIViewController {
    
    // MARK: Properties
    private var viewModel: CovidWebViewModel?
    private var webView: WKWebView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
        viewModel = CovidWebViewModel()
        setupWebView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarTitle()
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        tabBarController?.navigationItem.searchController = nil
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Setup
    private func setupWebView() {
        webView = WKWebView(frame: view.bounds) // size will be determined by auto-layout
        if let webView = webView {
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
            if let urlString = viewModel?.apiSourceWebURLString, let url = URL(string: urlString) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView?.scrollView.addSubview(refreshControl)
        webView?.scrollView.bounces = true
    }
    
    // MARK: - Update UI
    private func updateNavigationBarTitle() {
        tabBarController?.navigationItem.title = viewModel?.navigationTitle
    }
    
    // MARK: - Refresh Webview
    @objc
    private func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
}
