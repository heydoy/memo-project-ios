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
            return searchController.isActive
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
        //mainView.collectionView.delegate = self
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
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
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
        snapshot.appendSections([.unpinned])
        snapshot.appendItems(unpinList.toArray(), toSection: .unpinned)
        snapshot.appendSections([.pinned])
        snapshot.appendItems(pinList.toArray(), toSection: .pinned)
        dataSource.apply(snapshot)
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


