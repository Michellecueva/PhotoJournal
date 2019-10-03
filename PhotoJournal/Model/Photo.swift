//
//  Photo.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/30/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

struct Photo: Codable {
    let id: Int
    let description: String
    let time: String
    let image: Data
    
    static func getIDForNewPhoto() -> Int {
        do {
            let photos = try PhotoPersistenceHelper.manager.getPhoto()
            let max = photos.map{$0.id}.max() ?? 0
            return max + 1
        } catch {
            print(error)
        }
       return 0
    }
}

