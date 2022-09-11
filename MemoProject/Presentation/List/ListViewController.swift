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

protocol MemoDelegate: AnyObject {
    func updateMemo2(title: String, content: String?, dateCreated: Date, _id: ObjectId )
    func updateMemo(memo: Memo)
}

class ListViewController: BaseViewController {
    // MARK: - Properties
    
    let mainView = ListView()
    let repository = MemoRepository()
    
    var query = String() // 검색어
    var filterResult: Results<Memo>! { // 검색결과
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool {
        get {
            return searchController.isActive
        }
    }
    
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
        /// 다른 화면에 갔다가 다시 돌아올 경우 네비게이션 타이틀이 줄어드는 부분을 수정
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 저장 후 돌아오는 시점
        if repository.fetch() != list {
            fetchRealm()
        }
        /// Walkthrough 팝업 띄우기
        showWalkthroughPopup()
           
    }
    
    /// 네비게이션 바의 사이즈가 줄어들지 않는 부분을 수정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// 네비게이션 타이틀이 뷰가 전환될 때 잔상으로 남는 부분을 수정
        self.navigationItem.title = nil
        
        
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
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
       // definesPresentationContext = true
        
        
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
        vc.isEditing = true
        vc.editingMode = false // 새 메모라서 편집모드 X
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Table View
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    /// 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? 1 : 2 // 검색결과화면과 리스트
    }
    /// 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterResult == nil ? 0 : filterResult.count
        } else {
            if pinList == nil || unpinList == nil {
                return 0
            }
            return section == 0 ? pinList.count : unpinList.count
        }
    }
    
    /// 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        /// 검색 중일 때와 아닐 때 구분해서 데이터를 가져옴 (섹션이 고정메모일 때, 아닐 때)
        let item = isSearching ? filterResult[indexPath.row] : (indexPath.section == 0 ? pinList[indexPath.row] : unpinList[indexPath.row])
        cell.textLabel?.text = item.title
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        
        let dateString: String = dateFormat(for: item.dateCreated).replacingOccurrences(of: "\n", with: "")
        
        var contentString = ""
        
        if let content = item.content {
            contentString = content.replacingOccurrences(of: "\n", with: "")
        }
        cell.detailTextLabel?.text = "\(dateString)  \(contentString)"
        
        cell.detailTextLabel?.textColor = .systemGray
        
        /// 검색 중일 경우 쿼리에 해당하는 텍스트 색상과 볼드를 변경
        if isSearching {
            cell.detailTextLabel?.labelColorChange(query)
            cell.textLabel?.labelColorChange(query)

        }
        /// - 추가 텍스트 없음 
        if contentString.isEmpty {
            cell.detailTextLabel?.text = "\(dateString)  추가 텍스트 없음"
        }

        return cell
    }
    /// 셀 선택되었을 경우
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteViewController()
        vc.delegate = self
        vc.isEditing = false
        vc.editingMode = true // 기존메모 수정이므로 editingMode 는 참 
        if isSearching {
            self.navigationItem.backButtonTitle = "검색"
            let memo = filterResult[indexPath.row]
            vc.updateTextview(memo: memo)
            vc.editingMemo = memo
        } else {
            self.navigationItem.backButtonTitle = "메모"
            let memo = indexPath.section == 0 ? pinList[indexPath.row] : unpinList[indexPath.row]
            vc.updateTextview(memo: memo)
            vc.editingMemo = memo
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 셀 헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            let count = filterResult == nil ? 0 : filterResult.count
            return "\(count)개 찾음 "
        } else {
            if pinList != nil && pinList.count > 0 {
                return section == 0 ? "고정된 메모" : "메모"
            }
            else {
                return section == 0 ? nil : "메모"
            }
        }
    }

    /// - 헤더 폰트 설정
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
            /// 핀 갯수가 최대 개수를 넘어갈 경우
            if self.repository.fetchIsPinned(true).count == MemoPin.MaximumNumber && indexPath.section == 1 {
                /// 얼럿으로 알려주기
                self.showAlert(title: "고정메모는\n최대 \(MemoPin.MaximumNumber)개까지 가능합니다.", okText: "확인", cancelNeeded: false, completionHandler: nil)
                
                return
            } else {
                /// 배열이 두개로 관리되므로
                let item = indexPath.section == 0 ? self.pinList[indexPath.row] : self.unpinList[indexPath.row]
                self.repository.updatePin(item)
                self.list = self.repository.fetch()
                self.fetchRealm()
            }
            
        }
        let item = indexPath.section == 0 ? self.pinList[indexPath.row] : self.unpinList[indexPath.row]
        let pinImage = item.isPinned ? "pin.slash.fill" : "pin.fill"
        pin.image = UIImage(systemName: pinImage)
        pin.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [ pin ])
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

// MARK: - Search Bar Result Update
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        
        self.query = query
        self.filterResult = repository.fetchFilter(query)
    }
}

// MARK: - Memo Delegate Protocol
extension ListViewController: MemoDelegate {
    func updateMemo2(title: String, content: String?, dateCreated: Date, _id: ObjectId ) {
        self.repository.updateMemo2(title: title, content: content, dateCreated: dateCreated, _id: _id)
    }
    func updateMemo(memo: Memo) {
        self.repository.updateMemo(memo)
    }
}
