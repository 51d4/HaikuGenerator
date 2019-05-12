//
//  HaikuGeneratorTests.swift
//  HaikuGeneratorTests
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import XCTest

class HaikuPoemGeneratorTests: XCTestCase {

    func testGenerateFirstLine() {
        let expectedLine = "bitter wintertime"
        let expectedNumberOfSyllabes = 5
        
        HaikuGenerator().generateFirstLine() { generatedLine in
            let generatedCount = Haiku.shared.firstLineSyllablesCount

            XCTAssertEqual(generatedLine, expectedLine)
            XCTAssertEqual(generatedCount, expectedNumberOfSyllabes)
        }
    }
}
