//
//  HaikuGeneratorTests.swift
//  HaikuGeneratorTests
//
//  Created by Sida Nakrosyte on 05/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import XCTest

class ServiceManagerTests: XCTestCase {

    func testGenerateAWord() {
        let expectedWord = "tinnitus"
        let testParameters = "?ml=ringing+in+the+ears&max=4"
        
        ServiceManager().fetchWords(parameters: testParameters) {
            result in
            if let firstWord = result[0]["word"] as? String {
                XCTAssertEqual(firstWord, expectedWord)
            }
            XCTFail("Unexpected type")
        }
    }
}
