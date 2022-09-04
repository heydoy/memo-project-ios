//
//  UIViewController+Extension.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/02.
//

import Foundation
import UIKit

extension UIViewController {
    /// Walkthrough
    public func showWalkthroughPopup() {
        let walkthroughVC = WalkthroughViewController()
        self.present(walkthroughVC, animated: true)
    }
    
    /// Activity View Controller
    public func showActivityViewController(text: String) {
        
        let viewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        viewController.excludedActivityTypes = [ .assignToContact, .postToTencentWeibo, .postToVimeo, .postToFlickr, .saveToCameraRoll]
        
        self.present(viewController, animated: true)
        
    }
    
    /// Alert
    public func showAlert(title: String, okText: String, cancelNeeded: Bool, completionHandler: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: okText, style: .destructive, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        if cancelNeeded {
            alert.addAction(cancel)
        }
        self.present(alert, animated: true)
    }
    
    /// Number Format
    func numberFormat(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number)!
    }
    
    /// Date Format
    func dateFormat(for date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
                
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "a hh:mm" // 오늘
        } else if date.isInThisWeek() {
            dateFormatter.dateFormat = "EEEE" // 이번주
        } else {
            dateFormatter.dateFormat = "yyyy. MM. dd a hh:mm" // 그외
        }

        return dateFormatter.string(from: date)
    }
}
