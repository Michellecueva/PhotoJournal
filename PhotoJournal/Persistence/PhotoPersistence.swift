//
//  PhotoPersistence.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/30/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct PhotoPersistenceHelper {
    static let manager = PhotoPersistenceHelper()
    
    func save(newPhoto: Photo) throws {
        try persistenceHelper.save(newElement: newPhoto)
    }
    
    func getPhoto() throws -> [Photo] {
        return try persistenceHelper.getObjects()
    }
    
    func deletePhoto(withID: Int) throws {
        do {
            let photos = try getPhoto()
            let newPhotos = photos.filter { $0.id != withID}
            try persistenceHelper.replace(elements: newPhotos)
        }
    }
    
    func editPhoto(withID: Int, newPhoto: Photo) throws {
        do {
            let photos = try getPhoto()
            guard let indexOfOldPhoto = photos.firstIndex(where: {$0.id == withID}) else {return}
            try persistenceHelper.saveAtSpecificIndex(newElement: newPhoto, index: indexOfOldPhoto)
            try deletePhoto(withID: withID)
        }
    }
    
    private let persistenceHelper = PersistenceHelper<Photo>(fileName: "photos.plist")
    
    private init() {}
}
