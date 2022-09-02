//
//  UIViewController+Extension.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/02.
//

import Foundation
import UIKit

extension UIViewController {
    /// Activity View Controller
    public func showActivityViewController(text: String) {
        
        let viewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        viewController.excludedActivityTypes = [ .assignToContact, .postToTencentWeibo, .postToVimeo, .postToFlickr, .saveToCameraRoll]
        
        self.present(viewController, animated: true)
        
    }
}
