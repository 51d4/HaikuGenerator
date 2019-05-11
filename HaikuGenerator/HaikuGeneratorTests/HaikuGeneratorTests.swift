//
//  HaikuGeneratorTests.swift
//  HaikuGeneratorTests
//
//  Created by Sida Nakrosyte on 05/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import XCTest
@testable import HaikuGenerator

class HaikuGeneratorTests: XCTestCase {

    func testGenerateAWord() {
        let expected = "tinnitus"
        let testParameters = "?ml=ringing+in+the+ears&max=4"
        
        WordGenerator().generateWord(parameters: testParameters) {
            word in
            XCTAssertEqual(word, expected)
        }
    }

}
