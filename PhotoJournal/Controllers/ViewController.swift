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
    
    @IBOutlet weak var toolBar: UIToolbar!
    var photos = [Photo]() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    var cellColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        loadData()
        setSettings()
        setCellColor()
    }
    
 
    @IBAction func pushToAddEntryVC(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
        let AddPhotoVC = storyboard.instantiateViewController(withIdentifier: "addPhotoVC") as! AddPhotoEntryViewController
        
        AddPhotoVC.delegate = self
        self.present(AddPhotoVC, animated: true, completion: nil)
    }
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
        let SettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        SettingsVC.delegate = self
        
        self.present(SettingsVC, animated: true, completion: nil)
    }
    
    private func displayActionSheet(id: Int, photo: Photo) {

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
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
        })
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            
            let storyboard = UIStoryboard.init(name: "Main", bundle:nil)
            let AddPhotoVC = storyboard.instantiateViewController(withIdentifier: "addPhotoVC") as! AddPhotoEntryViewController
            
            AddPhotoVC.savedPhoto = photo
            AddPhotoVC.delegate = self
            
            self.present(AddPhotoVC, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
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
        cell.descriptionLabel.textColor = setTextColor()
        cell.timeLabel.text = photo.time
        cell.timeLabel.textColor = setTextColor()
        cell.backgroundColor = cellColor
        let image = UIImage(data: photo.image)
        
        cell.photoImage.image = image
        
        cell.buttonFunction = {
            self.displayActionSheet(id: photo.id, photo: photo)
        }
        
        cell.moreButton.setTitleColor(setTextColor(), for: .normal)
        return cell
    }
}


extension ViewController : LoadDataDelegate {
    func loadData() {
        do {
            photos = try PhotoPersistenceHelper.manager.getPhoto()
        } catch {
            print(error)
        }
    }
}

extension ViewController: SetSettingsDelegate {
    func setTextColor() -> UIColor {
         guard  let savedBackgroundColor = UserDefaultsWrapper.shared.getBackgroundMode() else {return UIColor.black}
                      
        let textColor = savedBackgroundColor == 0 ? UIColor.black : UIColor.white
        return textColor
    }
    
     func setCellColor()  {
         guard  let savedBackgroundColor = UserDefaultsWrapper.shared.getBackgroundMode() else {
            cellColor = UIColor.white
            return
        }
        let backgroundColor = savedBackgroundColor == 0 ? UIColor.white : UIColor.black
        
         photoCollectionView.reloadData()
        
        cellColor = backgroundColor
    }
    
     func setSettings() {
        
        if let savedBackgroundColor = UserDefaultsWrapper.shared.getBackgroundMode() {
            let backgroundColor = savedBackgroundColor == 0 ? UIColor.lightGray : UIColor.darkGray
            let barColor = savedBackgroundColor == 0 ? UIColor.groupTableViewBackground: UIColor.gray
            let itemColor = savedBackgroundColor == 0 ? UIColor.systemBlue: UIColor.white
            
            photoCollectionView.backgroundColor = backgroundColor
            toolBar.barTintColor = barColor
            toolBar.tintColor = itemColor
            navigationController?.navigationBar.barTintColor = barColor
        }
        
        if let savedScrollDirection = UserDefaultsWrapper.shared.getScrollDirection() {
            let direction = savedScrollDirection == 0 ? UICollectionView.ScrollDirection.vertical : UICollectionView.ScrollDirection.horizontal
            
            if let layout = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = direction
            }
        }
        
    }
}
