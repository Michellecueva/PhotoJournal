//
//  AddPhotoEntryViewController.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/28/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit
import AVFoundation

class AddPhotoEntryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var entryImage: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    weak var delegate: LoadDataDelegate?
    
    var savedPhoto: Photo!
    
    var descriptionPlaceHolder = "Enter photo description..."
    
    var defaultImage = UIImage(named: "noImage")
    
    var savedImage : UIImage! {
        didSet {
            entryImage.image = savedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUserSettings()
        setEditingPhoto()
    }
    
    @IBAction func AddPhotoFromLibrary(_ sender: UIBarButtonItem) {
        checkAuthorizationForAccessingPhotos()
    }
    
    @IBAction func TakePicture(_ sender: UIBarButtonItem) {
        checkAuthorizationForAccessingPhotos()
    }
    
    @IBAction func savePhoto(_ sender: UIBarButtonItem) {
        guard let text = textView.text else {return}
        guard let image = entryImage.image else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        let photo = Photo(id: Photo.getIDForNewPhoto(),description: text, image: data)

        do {
            if savedPhoto != nil {
                try PhotoPersistenceHelper.manager.editPhoto(withID: savedPhoto.id, newPhoto: photo)
            } else {
                try PhotoPersistenceHelper.manager.save(newPhoto: photo)
            }
             delegate?.loadData()
        }catch {
            print(error)
            
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelWithoutSaving(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUserSettings() {
        guard let userSettings = UserDefaultsWrapper.shared.getBackgroundMode() else {return}
        
        let textViewColor = userSettings == 0 ? UIColor.white : UIColor.black
        let backgroundColor =  userSettings == 0 ? UIColor.lightGray: UIColor.darkGray

        textView.backgroundColor = textViewColor
        self.view.backgroundColor = backgroundColor
             
    }
    
    private func setEditingPhoto() {
        if savedPhoto != nil {
            textView.text = savedPhoto.description
            let image = UIImage(data: savedPhoto.image)
            entryImage.image =  image
            formValidation()
            
            guard let userSettings = UserDefaultsWrapper.shared.getBackgroundMode() else {
                textView.textColor = .black
                return
            }
            let textViewColor = userSettings == 0 ? UIColor.black : UIColor.white
            textView.textColor = textViewColor
        }
    }
    
    private func configureTextView() {
        textView.text = descriptionPlaceHolder
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        formValidation()
    }
    
    private func configureImage() {
        if entryImage.image == nil {
            entryImage.image = defaultImage
        }
    }
    
    private func formValidation() {
        let validUserInput = textView.text != descriptionPlaceHolder
        let imagePresent = entryImage.image != defaultImage
        saveButton.isEnabled = validUserInput && imagePresent
    }

    
    private func setupCaptureSession() {
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            self.present(myPickerController, animated: true, completion: nil)

        }
    }

    private func checkAuthorizationForAccessingPhotos() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            return setupCaptureSession()
    
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
            
        case .denied: // The user has previously denied access.
            return alertCameraAccessNeeded()
            
        case .restricted: // The user can't grant access due to restrictions.
            return
            
        default:
            return
        }
    }
    
    private func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
      
        let alert = UIAlertController(
        title: "Need Camera Access",
                message: "Camera access is required to make full use of this app.",
                preferredStyle: UIAlertController.Style.alert
            )
      
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
           UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}


extension AddPhotoEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        savedImage = image
        formValidation()
        entryImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddPhotoEntryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && savedPhoto == nil {
            textView.text = nil
            textView.textColor = UIColor.black
            formValidation()
        }
        
        guard let userSettings = UserDefaultsWrapper.shared.getBackgroundMode() else {return}
        let textViewColor = userSettings == 0 ? UIColor.black : UIColor.white
        textView.textColor = textViewColor
        formValidation()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.lightGray
            formValidation()
        }
    }
}
