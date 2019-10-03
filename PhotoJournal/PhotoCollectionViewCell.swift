//
//  PhotoCollectionViewCell.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/28/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var buttonFunction: (()->())?
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        if let closure = buttonFunction {
            closure()
        }
    }
    
}
