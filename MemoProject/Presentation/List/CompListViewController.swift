//
//  CompListViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/10/20.
//

import UIKit
import SnapKit
import Then
import RealmSwift

enum Section {
    case pinned
    case unpinned
    case search
}

typealias Item = Memo

class CompListViewController: BaseViewController {
    // MARK: - Properties
    let mainView = CompListView()
    let repository = MemoRepository()
    
    var query = String() // 검색어
    var filterResult: Results<Memo>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool {
        get {
            let searchable = searchController.isActive
            navigationItem.backButtonTitle = searchable ? "검색" : "메모"
            return searchable
        }
    }
    
    var list: Results<Memo>! {
        didSet {
            self.navigationItem.title = "\(numberFormat(for: list.count))개의 메모"
            
            self.configureDataSource()
        }
    }
    
    var pinList: Results<Memo>!
    var unpinList: Results<Memo>!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
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
    
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = createLayout()
        configureDataSource()
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
        pinList = repository.fetchPinnedMemo(true)
        unpinList = repository.fetchPinnedMemo(false)
    }
    
    @objc func makeMemoButtonTapped(_ sender: UIBarButtonItem) {
        let vc = WriteViewController()
        vc.isEditing = true
        vc.editingMode = false // 새 메모라서 편집모드 X
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompListViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.leadingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let pin = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                /// 핀 갯수가 최대 개수를 넘어갈 경우
                if self.repository.fetchPinnedMemo(true).count == MemoPin.MaximumNumber && indexPath.section == 1 {
                    /// 얼럿으로 알려주기
                    self.showAlert(title: "고정메모는\n최대 \(MemoPin.MaximumNumber)개까지 가능합니다.", okText: "확인", cancelNeeded: false, completionHandler: nil)
                    
                    return
                } else {
                    let item = self.dataSource.itemIdentifier(for: indexPath)!
                    self.repository.updatePin(item)
                    self.list = self.repository.fetch()
                    self.fetchRealm()
                }
                
            }
            let item = self.dataSource.itemIdentifier(for: indexPath)!
            let pinImage = item.pinnedMemo ? "pin.slash.fill" : "pin.fill"
            pin.image = UIImage(systemName: pinImage)
            pin.backgroundColor = .systemOrange
            
            return UISwipeActionsConfiguration(actions: [ pin ])
            
            
        }
        config.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
                // 삭제하기
                self.showAlert(title: "삭제하시겠습니까?", okText: "네, 삭제합니다.", cancelNeeded: true) { action in
                    let item = self.dataSource.itemIdentifier(for: indexPath)!
                    
                    self.repository.deleteMemo(item)
                    self.fetchRealm()
                }
            }
            delete.image = UIImage(systemName: "trash.fill")
            delete.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [delete])
        
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        
        // Cell Registration
        let cellRegistration =  UICollectionView.CellRegistration<UICollectionViewListCell, Memo>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.textProperties.font = .boldSystemFont(ofSize: 14)
            content.secondaryTextProperties.font = .systemFont(ofSize: 12)
            
            content.text = itemIdentifier.title
            
            let dateString: String = self.dateFormat(for: itemIdentifier.dateCreated).replacingOccurrences(of: "\n", with: "")
            
            var contentString = ""
            
            if let content = itemIdentifier.content {
                contentString = content.replacingOccurrences(of: "\n", with: "")
            }
            
            content.prefersSideBySideTextAndSecondaryText = false
            content.secondaryText = "\(dateString)  \(contentString)"
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .systemBackground
            cell.backgroundConfiguration = background
            
        })
        
        // Diffable Data Source
        // collectionView.dataSource = self 코드의 대체
        // CellForItemAt 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration , for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        // 스냅샷, 모델을 Initialise 해줄 것
        // 스냅샷 타입은 위에 dataSource형태와 맞추기 (섹션Int, 모델타입)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        guard let unpinList = unpinList, let pinList = pinList else { return }
        snapshot.appendSections([.pinned])
        snapshot.appendItems(pinList.toArray(), toSection: .pinned)
        snapshot.appendSections([.unpinned])
        snapshot.appendItems(unpinList.toArray(), toSection: .unpinned)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
// MARK: - Collection View Delegate
extension CompListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WriteViewController()
        vc.delegate = self
        vc.isEditing = false
        vc.editingMode = true // 기존메모 수정이므로 editingMode는 참
        
        guard let memo = dataSource.itemIdentifier(for: indexPath) else { return }
        vc.updateTextview(memo: memo)
        vc.editingMemo = memo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Search Bar Result Update
extension CompListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        
        self.query = query
        filterResult = repository.fetchFilter(query)
        
        guard let filterResult = filterResult else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.search])
        snapshot.appendItems(filterResult.toArray(), toSection: .search)
        dataSource.apply(snapshot)
    }
}

// MARK: - Memo Delegate Protocol
extension CompListViewController: MemoDelegate {
    func updateMemo2(title: String, content: String?, dateCreated: Date, _id: ObjectId ) {
        self.repository.updateMemo2(title: title, content: content, dateCreated: dateCreated, _id: _id)
    }
    func updateMemo(memo: Memo) {
        self.repository.updateMemo(memo)
    }
}


