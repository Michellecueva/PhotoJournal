//
//  Protocols.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 10/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

protocol LoadDataDelegate: AnyObject {
    func loadData()
}

protocol SetSettingsDelegate: AnyObject {
    func setSettings()
    func setCellColor () 
    func setTextColor() -> UIColor
}

