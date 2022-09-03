//
//  BaseViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        configure()
        setNavigationBar()

    }
    
    func configure() { }
    func setNavigationBar() {
        /// Bar Appearances
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        /// Tint Color
        self.navigationController?.navigationBar.tintColor = .systemOrange
    }

    
}
