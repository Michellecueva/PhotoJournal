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
    
    @IBOutlet weak var scrollLabel: UILabel!
    
    @IBOutlet weak var backgroundLabel: UILabel!
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    
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
        setSegments()
        setBackgroundModeForView()
    }
    
    
    @IBAction func changeScrollDirection(_ sender: UISegmentedControl) {
        scrollDirection = sender.selectedSegmentIndex
        delegate?.setSettings()
    }
    
    
    @IBAction func changeBackgroundMode(_ sender: UISegmentedControl) {
        backgroundMode = sender.selectedSegmentIndex
        setBackgroundModeForView()
        delegate?.setSettings()
        delegate?.setCellColor()
    }
    
    private func setSegments() {
        
        guard let savedScrollDirection = UserDefaultsWrapper.shared.getScrollDirection() else {return}
        guard  let savedBackgroundMode = UserDefaultsWrapper.shared.getBackgroundMode() else {return}
        
        scrollDirectionSegment.selectedSegmentIndex = savedScrollDirection
        BackgroundModeSegment.selectedSegmentIndex = savedBackgroundMode
    }
    
    private func setBackgroundModeForView() {
        
        let textColor = backgroundMode == 0 ? UIColor.black : UIColor.white
        let settingsColor = backgroundMode == 0 ? UIColor.systemBlue : UIColor.white
        let backgroundColor = backgroundMode == 0 ? UIColor.groupTableViewBackground : UIColor.black
        let segmentColor = backgroundMode == 0 ? UIColor.lightText : UIColor.darkGray
               
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        scrollDirectionSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        BackgroundModeSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        scrollDirectionSegment.backgroundColor = segmentColor
        BackgroundModeSegment.backgroundColor = segmentColor
        scrollLabel.textColor = textColor
        backgroundLabel.textColor = textColor
        settingsLabel.textColor = settingsColor
        self.view.backgroundColor = backgroundColor
    }
    
    
}
