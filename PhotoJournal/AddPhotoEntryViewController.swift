//
//  AddPhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/28/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class AddPhotoEntryViewController: UIViewController {
    
    @IBOutlet weak var entryImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddPhotoFromLibrary(_ sender: UIBarButtonItem) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
}

extension AddPhotoEntryViewController: UINavigationControllerDelegate {
    
}

extension AddPhotoEntryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        entryImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        entryImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)

    }
    
  
}

