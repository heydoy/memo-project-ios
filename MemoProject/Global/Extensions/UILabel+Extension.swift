//
//  UILabel+Extension.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/04.
//

import Foundation
import UIKit

extension UILabel {
    /// 라벨 색상 변경
    public func labelColorChange(_ query: String ) {
        // 레이블에 글자가 있는지 체크
        guard let wholeString = self.text else {
            print("레이블에 문자열이 없습니다")
            return }
        
        // 설정하려는 폰트와 컬러 (현재 폰트X)
//        let customFont = UIFont.boldSystemFont(ofSize: 14)
        let customColor = UIColor.systemOrange
        
        // 설정하고자 하는 쿼리 스트링의 NSRanges
        let customQueryRange = (wholeString as NSString).range(of: query )
        
        
        // Attribute 객체를 생성한다.
        let attributedString = NSMutableAttributedString(string: wholeString)
        
//        attributedString.addAttribute(.font, value: customFont, range: customQueryRange)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: customQueryRange)

        self.attributedText = attributedString
    }
}
