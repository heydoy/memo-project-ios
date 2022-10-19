//
//  CompListView.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/10/20.
//

import UIKit

class CompListView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout() ).then {
        
        $0.backgroundColor = .clear
    }


    override func setupUI() {
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
