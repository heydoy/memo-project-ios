//
//  WriteViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import UIKit

class WriteViewController: BaseViewController {
    // MARK: - Properties
    
    let mainView = WriteView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Helpers
    override func configure() {
        //mainView.textView.delegate = self
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        /// Navigation Item
        /// - Right Bar Button Item
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: nil)
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        
        let items = [ finishButton, shareButton  ]
        items.forEach { $0.tintColor = .systemOrange }
        
        navigationItem.rightBarButtonItems = items
        
    }
}
