//
//  WriteViewController.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/03.
//

import UIKit
import RealmSwift

class WriteViewController: BaseViewController {
    // MARK: - Properties
    weak var delegate: MemoDelegate?
    var editingMode: Bool = false
    var editingMemo = Memo()
    let mainView = WriteView()
    let repository = MemoRepository()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        saveText()
    }

    // MARK: - Helpers
    override func configure() {
        /// 기존 메모 선택해서 들어왔을 경우 바버튼을 숨긴다
        if editingMode {
            setBarButton(false)
        } else {
            setBarButton(true)
        }
        mainView.textView.delegate = self
        
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        /// Navigation Item
    }
    
    // MARK: - Actions
    func updateTextview(memo: Memo) {
        isEditing = false
        
        if let content = memo.content {
            mainView.textView.text = memo.title + content
        } else {
            mainView.textView.text = memo.title
        }
        
        
    }
    
    /// 텍스트 Realm에 저장하는 함수
    func saveText() {
        guard let text = mainView.textView.text, !text.isEmpty else { return }
        if let index = text.firstIndex(of: "\n"){
            let title = String(text[..<index])
            let content = String(text[index...])
            let item = Memo(title: title, content: content, dateCreated: Date())
            
            if editingMode { /// - 메모 편집할 때
                delegate?.updateMemo2(title: title, content: content, dateCreated: Date(), _id: editingMemo._id)
            }
            else {
                repository.createMemo(item)
            }
            
        } else { /// - 새 메모 만들 때
            let item = Memo(title: text, content: nil, dateCreated: Date())
            if editingMode {
                delegate?.updateMemo2(title: text, content: nil, dateCreated: Date(), _id: editingMemo._id)
            }
            else {
                repository.createMemo(item)
            }
        }
    }
    
    /// 공유버튼 눌렀을 경우
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        if let text = mainView.textView.text, !text.isEmpty {
        showActivityViewController(text: text)
        } else { // 텍스트가 비었을 경우 얼럿으로 알려줌
            showAlert(title: "공유할 내용이 없습니다.", okText: "확인", cancelNeeded: false, completionHandler: nil)
        }
    }
    
    /// 완료버튼 눌렀을 경우
    @objc func finishButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 바버튼
    func setBarButton(_ bool : Bool) {
        /// - Right Bar Button Item
        if bool {
            /// - 키보드도 올라오게 해준다. 
            mainView.textView.becomeFirstResponder()
            
            let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
            let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
            
            let items = [ finishButton, shareButton  ]
            items.forEach { $0.tintColor = .systemOrange }
            
            navigationItem.rightBarButtonItems = items
        } else {
            navigationItem.rightBarButtonItems = nil
        }
    }
}

// MARK: - UITextView Delegate

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setBarButton(true)
        
    }
}
