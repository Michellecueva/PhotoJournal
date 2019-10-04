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
    
    var scrollDirection = 0 {
        didSet {
            scrollDirectionSegment.selectedSegmentIndex = scrollDirection
            UserDefaultsWrapper.shared.store(scrollDirection: scrollDirection)
        }
    }
    
    var backgroundMode = 0 {
        didSet {
            BackgroundModeSegment.selectedSegmentIndex = backgroundMode
            UserDefaultsWrapper.shared.store(backgroundMode: backgroundMode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(scrollDirectionSegment.selectedSegmentIndex)
        print(BackgroundModeSegment.selectedSegmentIndex)
    }
    
    
    @IBAction func changeScrollDirection(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Int should be 0")
        } else  {
            print("Int should be 1")
        }
    }
    
    
    @IBAction func changeBackgroundMode(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Int should be 0")
        } else  {
            print("Int should be 1")
        }
    }
    
    
}
