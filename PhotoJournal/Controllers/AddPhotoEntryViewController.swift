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
    
    var savedImage : UIImage! {
        didSet {
            entryImage.image = savedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
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
        
        let photo = Photo(id: Photo.getIDForNewPhoto(),description: text, time: getCurrentTime(), image: data)

        do {
            try PhotoPersistenceHelper.manager.save(newPhoto: photo)
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
    
    
    func checkAuthorizationForAccessingPhotos() {
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
    
    func configureTextView() {
        textView.text = "Enter photo description..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    
    func getCurrentTime() -> String {
        
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return formatter.string(from: now)
    }
    
    func setupCaptureSession() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        self.present(myPickerController, animated: true, completion: nil)
    }

    
    func alertCameraAccessNeeded() {
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
        entryImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)

    }
    
  
}

extension AddPhotoEntryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter photo description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}

