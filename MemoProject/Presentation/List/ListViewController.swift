//
//  ListViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/02.
//

import UIKit
import SnapKit
import Then
import RealmSwift

final class ListViewController: BaseViewController {
    // MARK: - Properties
    
    let mainView = ListView()
    let repository = MemoRepository()
    var list: Results<Memo>! {
        didSet {
            mainView.tableView.reloadData()
            self.navigationItem.title = "\(numberFormat(for: list.count))개의 메모"
        }
    }
    
    var pinList: Results<Memo>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    var unpinList: Results<Memo>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    

    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 저장 후 돌아오는 시점
        if repository.fetch() != list {
            fetchRealm()
        }
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
    func fetchRealm() {
        list = repository.fetch() // 저장시점이랑 viewWillAppear 시점이 다르다.
        pinList = repository.fetchIsPinned(true)
        unpinList = repository.fetchIsPinned(false)
    }
    
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
        if pinList == nil || unpinList == nil {
            return 0
        }
        return section == 0 ? pinList.count : unpinList.count
    }
    
    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let item = indexPath.section == 0 ? pinList[indexPath.row] : unpinList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        
        let dateString: String = dateFormat(for: item.dateCreated).replacingOccurrences(of: "\n", with: "")
        
        var contentString = ""
        
        if let content = item.content {
            contentString = content.replacingOccurrences(of: "\n", with: "")
        }
        cell.detailTextLabel?.text = "\(dateString)  \(contentString)"
        
        cell.detailTextLabel?.textColor = .systemGray

        return cell
    }
    
    /// 셀 헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pinList != nil && pinList.count > 0 {
            return section == 0 ? "고정된 메모" : "메모"
        }
        else {
            return section == 0 ? nil : "메모"
        }
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
            // 핀하기
            if self.repository.fetchIsPinned(true).count == MemoPin.MaximumNumber && indexPath.section == 1 {
                // 얼럿으로 알려주기
                self.showAlert(title: "고정메모는\n최대 \(MemoPin.MaximumNumber)개까지 가능합니다.", okText: "확인", cancelNeeded: false, completionHandler: nil)
                
                return
            } else {
                // 배열이 두개로 관리되므로
                let item = indexPath.section == 0 ? self.pinList[indexPath.row] : self.unpinList[indexPath.row]
                self.repository.updatePin(item)
                self.list = self.repository.fetch()
                self.fetchRealm()
            }
            
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
            self.showAlert(title: "삭제하시겠습니까?", okText: "네, 삭제합니다.", cancelNeeded: true) { action in
                let item = indexPath.section == 0 ? self.pinList[indexPath.row] : self.unpinList[indexPath.row]
                
                self.repository.deleteMemo(item)
                self.fetchRealm()
                
            }
            
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
