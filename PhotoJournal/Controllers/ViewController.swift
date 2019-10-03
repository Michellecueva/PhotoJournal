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
    
    func displayActionSheet(id: Int) {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:
        
            { (action) in
                
                DispatchQueue.global(qos: .utility).async {
                    do {
                        try PhotoPersistenceHelper.manager.deletePhoto(withID: id)
                        
                        DispatchQueue.main.async {
                            do {
                                self.photos = try PhotoPersistenceHelper.manager.getPhoto()
                            } catch {
                                //couldn't get favorites
                            }
                        }
                    } catch {
                        //could not favorite, try again later
                    }
                }
        })
        let editAction = UIAlertAction(title: "Edit", style: .default)
//        let shareAction = UIAlertAction(title: "Share", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
//        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        
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
            self.displayActionSheet(id: photo.id)
        }
     
        return cell
    }
}


