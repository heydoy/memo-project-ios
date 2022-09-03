//
//  ListViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/02.
//

import UIKit
import SnapKit
import Then

class ListViewController: BaseViewController {
    // MARK: - Properties
    
    let mainView = ListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                

    }
    
    
    // MARK: - Helpers
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    
    override func setNavigationBar() {
        super.setNavigationBar()
        /// Navigation Item
        /// - Title
        self.navigationItem.title = "0개의 메모"
        self.navigationItem.backButtonTitle = "메모"
        /// -- 타이틀을 크게 설정
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        
        /// - Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        
        navigationItem.searchController = searchController
        /// -- 스크롤이 되더라도 검색바가 보이게 설정
        navigationItem.hidesSearchBarWhenScrolling = false
        
        /// - Toolbar
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.backgroundColor = .systemBackground
        let makeMemoButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(makeMemoButtonTapped))
        makeMemoButton.tintColor = .systemOrange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, makeMemoButton]
        
    
    }
    
    // MARK: - Actions
    
    @objc func makeMemoButtonTapped(_ sender: UIBarButtonItem) {
        let vc = WriteViewController()

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

// MARK: - Table View
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    /// 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    /// 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = "고기리 들기름 막국수 11시 오픈"
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = "화요일  오픈 10분전부터 웨이팅 등록 가능"
        cell.detailTextLabel?.textColor = .systemGray

        return cell
    }
    
    /// 셀 헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "고정된 메모" : "메모"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.textLabel?.textColor = UIColor.label
        header.textLabel?.textAlignment = .left

    }
    /// 스와이프 액션
    /// - 고정하기
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            // 액션코드
        }
        let pinImage =  "pin.fill" // OR  "pin.slash.fill"
        pin.image = UIImage(systemName: pinImage)
        pin.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [ pin])
    }
    /// - 삭제하기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            // 삭제하기
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
