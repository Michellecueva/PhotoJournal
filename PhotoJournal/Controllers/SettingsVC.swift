//
//  SettingsVC.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 10/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var scrollDirectionSegment: UISegmentedControl!
    
    @IBOutlet weak var BackgroundModeSegment: UISegmentedControl!
    
    var delegate: SetSettingsDelegate?
    
    var scrollDirection = 0 {
        didSet {
            UserDefaultsWrapper.shared.store(scrollDirection: scrollDirection)
        }
    }
    
    var backgroundMode = 0 {
        didSet {
            UserDefaultsWrapper.shared.store(backgroundMode: backgroundMode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let savedScrollDirection = UserDefaultsWrapper.shared.getScrollDirection() else {return}
        scrollDirectionSegment.selectedSegmentIndex = savedScrollDirection
        
        guard  let savedBackgroundMode = UserDefaultsWrapper.shared.getBackgroundMode() else {
            return
        }
        BackgroundModeSegment.selectedSegmentIndex = savedBackgroundMode
    }
    
    
    @IBAction func changeScrollDirection(_ sender: UISegmentedControl) {
        scrollDirection = sender.selectedSegmentIndex
        delegate?.setSettings()
    }
    
    
    @IBAction func changeBackgroundMode(_ sender: UISegmentedControl) {
        backgroundMode = sender.selectedSegmentIndex
        delegate?.setSettings()
        delegate?.setCellColor()
    }
    
    
}
