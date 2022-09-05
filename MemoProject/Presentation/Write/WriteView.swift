//
//  WriteView.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import UIKit
import Then
import SnapKit


class WriteView: BaseView {
    
    // MARK: - Properties
    public lazy var textView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 24, left: 20, bottom: 20, right: 20)
        $0.font = .boldSystemFont(ofSize: 14)
    }

    // MARK: - UI
    override func setupUI() {
        self.addSubview(textView)
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    

}
