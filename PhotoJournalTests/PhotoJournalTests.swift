//
//  PhotoJournalTests.swift
//  PhotoJournalTests
//
//  Created by Michelle Cueva on 9/27/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import XCTest
@testable import PhotoJournal

class PhotoJournalTests: XCTestCase {
    
    var imageOne: UIImage!
    var imageTwo: UIImage!
    var imageThree: UIImage!
    var dataOne: Data!
    var dataTwo: Data!
    var dataThree: Data!
    var picOne: Photo!
    var picTwo: Photo!
    var picThree: Photo!

    override func setUp() {
        guard let picImageOne = UIImage(named: "MorrisPt") else {return}
        guard let picDataOne = picImageOne.jpegData(compressionQuality: 0.5) else { return }
        guard let picImageTwo = UIImage(named: "monumentValley") else {return}
        guard let picDataTwo = picImageTwo.jpegData(compressionQuality: 0.5) else { return }
        guard let picImageThree = UIImage(named: "Zion") else {return}
        guard let picDataThree = picImageThree.jpegData(compressionQuality: 0.5) else { return }
        
        imageOne = picImageOne
        imageTwo = picImageTwo
        imageThree = picImageThree
        
        dataOne = picDataOne
        dataTwo = picDataTwo
        dataThree = picDataThree
        
        picOne = Photo(id: 1, description: "Sample One", image: dataOne)
        picTwo = Photo(id: 2, description: "Sample Two", image: dataTwo)
        picThree = Photo(id: 3, description: "Sample Three", image: dataThree)
    }

    override func tearDown() {
        imageOne = nil
        imageTwo = nil
        imageThree = nil
        dataOne = nil
        dataTwo = nil
        dataThree = nil
        picOne = nil
        picTwo = nil
        picThree = nil
    }

    func testPhotoId() {
        XCTAssert(picOne.id == 1, "The id for this photo is incorrect")
        XCTAssert(picOne.id != picTwo.id, "The id for these two objects are the same")
    }

    func testPhotoDescription() {
        XCTAssert(picOne.description == "Sample One", "The description for this photo is incorrect")
    }
    
    func testPhotoImage() {
        XCTAssert(type(of: picThree.image) == Data.self, "dateThree does not return Data")
    }
    
}
