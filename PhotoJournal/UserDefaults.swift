//
//  UserDefaults.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 10/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

class UserDefaultsWrapper {
    
    static let shared = UserDefaultsWrapper()
    
    func getScrollDirection() -> Int? {
        return UserDefaults.standard.value(forKey: scrollDirectionKey) as? Int
    }
    
    func getBackgroundMode() -> Int? {
        return UserDefaults.standard.value(forKey: backgroundModeKey) as? Int
    }
    
    func store(scrollDirection: Int) {
        UserDefaults.standard.set(scrollDirection, forKey: scrollDirectionKey)
    }
    
    func store(backgroundMode: Int) {
        UserDefaults.standard.set(backgroundMode, forKey: backgroundModeKey)
    }
    
    private let scrollDirectionKey = "scrollDirectionValue"
    private let backgroundModeKey = "backgroundModeValue"
}
