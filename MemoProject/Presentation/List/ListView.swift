//
//  ListView.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import UIKit

class ListView: BaseView {
    // MARK: - Properties
    lazy var tableView = UITableView(frame: .init(), style: .insetGrouped).then {
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    override func setupUI() {
        /// View
        
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    

}
