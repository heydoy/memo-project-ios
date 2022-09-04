//
//  UILabel+Extension.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/04.
//

import Foundation
import UIKit

extension UILabel {
    /// 쿼리와 일치하는 레이블 텍스트의 색상 변경
    public func labelColorChange(_ query: String ) {
        /// 레이블에 글자가 있는지 체크
        guard let wholeString = self.text else {
            print("레이블에 문자열이 없습니다")
            return }
        
        /// 설정하려는 폰트와 컬러 (현재 폰트X)
        let customColor = UIColor.systemOrange
        
        /// 설정하고자 하는 쿼리 스트링의 NSRanges
        //let customQueryRange = (wholeString as NSString).range(of: query)
        
        /// Attribute 객체를 생성한다.
        let attributedString = NSMutableAttributedString(string: wholeString)
        /// 쿼리와 일치하는 문자를 찾으려는 전체문자열의 길이
        let entireLength = wholeString.count
        var range = NSRange(location: 0, length: entireLength)
        
        /// range를 저장할 배열
        var rangeArray = [NSRange]()
        
        /// 반복문으로 쿼리가 일치하는 range를 찾아 저장해준다.
        while (range.location != NSNotFound) {
            range = (attributedString.string as NSString).range(of: query, options: .caseInsensitive, range: range)
            rangeArray.append(range)
            if range.location != NSNotFound {
                let location = range.location + range.length
                range = NSRange(location: location  , length: entireLength - location)
            }
        }
        
        rangeArray.indices.forEach { index in
            /// 속성 지정
            attributedString.addAttribute(.foregroundColor, value: customColor, range: rangeArray[index])
        }

        /// 레이블에 지정
        self.attributedText = attributedString
    }
}
