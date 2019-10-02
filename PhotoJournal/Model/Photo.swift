//
//  Photo.swift
//  PhotoJournal
//
//  Created by Michelle Cueva on 9/30/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

struct Photo: Codable {
    let description: String
    let time: Date
    let image: Data
}
