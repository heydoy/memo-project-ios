//
//  ListViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/02.
//

import UIKit

import UIKit

class ListViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setConstraints()

    }
    // MARK: - Actions
    
    
    // MARK: - Helpers
    
    func setupUI() {
        /// View
        self.view.backgroundColor = .systemBackground
        /// Navigation Item
        /// - Title

        self.navigationItem.title = "0개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        /// - Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func setConstraints() {
        
    }
    



}
