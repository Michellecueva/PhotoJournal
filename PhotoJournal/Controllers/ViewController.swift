//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/27/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos = [Photo]() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
 
    @IBAction func pushToAddEntryVC(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
        let AddPhotoVC = storyboard.instantiateViewController(withIdentifier: "addPhotoVC") as! AddPhotoEntryViewController
        
        self.present(AddPhotoVC, animated: true, completion: nil)

    }
    
    func loadData(){
        do {
            photos = try PhotoPersistenceHelper.manager.getPhoto()
            
        } catch {
            print(error)
        }
    }
    
    func displayActionSheet() {
        
        //        guard let indexPath = photoCollectionView?.indexPath(for: (((sender as AnyObject).superview?.superview) as! PhotoCollectionViewCell)) else {fatalError()}
        //            let photo = photos[indexPath.row]
        
        
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let editAction = UIAlertAction(title: "Edit", style: .default)
        let shareAction = UIAlertAction(title: "Share", style: .default)
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.row]
        cell.descriptionLabel.text = photo.description
        cell.timeLabel.text = photo.time
        
        let image = UIImage(data: photo.image)
        
        cell.photoImage.image = image
        
        cell.buttonFunction = {
            self.displayActionSheet()
        }
     
        return cell
    }
}


