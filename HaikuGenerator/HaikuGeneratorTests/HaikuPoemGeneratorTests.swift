//
//  HaikuGeneratorTests.swift
//  HaikuGeneratorTests
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import XCTest

class HaikuPoemGeneratorTests: XCTestCase {

    func testGenerateRandomFirstLine() {
        let expectedMinSyllablesCount = 4
        HaikuGenerator().generateFirstLine { (firstLine) in
            let generatedCount = Haiku.shared.firstLineSyllablesCount
            
            XCTAssertNotEqual(firstLine, "")
            XCTAssertGreaterThan(generatedCount, expectedMinSyllablesCount)
        }
    }
}
