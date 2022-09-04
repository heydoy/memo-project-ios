//
//  LandscapeManager.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/04.
//

import Foundation

class LandscapeManager {
    static let shared = LandscapeManager()
    // 앱이 처음 열린건지 아닌지 체크하기
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(!newValue, forKey: #function)
        }
    }
 
}
