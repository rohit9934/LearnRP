//
//  LearnRPTests.swift
//  LearnRPTests
//
//  Created by Rohit Sharma on 22/05/23.
//

import XCTest
import UIKit
@testable import LearnRP

final class LearnRPTests: XCTestCase {

    func test_IfValuesAreNil() {
        let sut = createSUT()
        let secondSUT = createSecondSUT(thing: sut.myThing)
        secondSUT?.loadViewIfNeeded()
        XCTAssertEqual(sut.myThing, secondSUT?.thing)
    }
    func createSUT() -> ViewController {
        let vc = ViewController.init()
        return vc
    }
    func createSecondSUT(thing: String) -> SecondViewController? {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondViewController") { coder -> SecondViewController? in
            SecondViewController(coder: coder,thing: thing)
        }
        return vc
    }
    func testFetchImage() {
        let expectation = XCTestExpectation(description: "Image fetched successfully")
        
        let imageURL = URL(string: "https://images.dog.ceo/breeds/spaniel-cocker/n02102318_12877.jpg")!
        let imageService: ImageService = NetworkManager() // Replace with the actual class that contains fetchImage
        
        imageService.fetchImage(url: imageURL) { image in
            XCTAssertNotNil(image, "Image should not be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed
        }
    
}
