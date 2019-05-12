//
//  HaikuGeneratorTests.swift
//  HaikuGeneratorTests
//
//  Created by Sida Nakrosyte on 05/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import XCTest

class ServiceManagerTests: XCTestCase {
    private let serviceManager = ServiceManager()
    
    private func generateFirstLine(completion: @escaping (_ firstLine: String) -> Void) {
        generateNoun { (noun) in
            self.generateAdjective(basedOn: noun, completion: { (adjective) in
                completion(adjective + " " + noun)
            })
        }
    }
    
    private func generateNoun(completion: @escaping (_ adjective: String) -> Void) {
        serviceManager.fetchWords(parameters: "?ml=winter&md=s&max=4") { (result) in
            if let noun = result[0]["word"] as? String, let syllables = result[0]["numSyllables"] as? Int {
                print(noun + " \(syllables)")
                Haiku.shared.firstLineSyllablesCount = syllables
                
                completion(noun)
            }
        }
    }
    
    private func generateAdjective(basedOn noun: String, completion: @escaping (_ adjective: String) -> Void) {
        serviceManager.fetchWords(parameters: "?rel_jjb=\(noun)&md=s&max=4") { (result) in
            for dictionary in result {
                if let adjective = dictionary["word"] as? String,
                    let syllables = dictionary["numSyllables"] as? Int,
                    syllables == 5 - Haiku.shared.firstLineSyllablesCount {
                    print(adjective + " \(syllables)")
                    
                    Haiku.shared.firstLineSyllablesCount = Haiku.shared.firstLineSyllablesCount + syllables
                    completion(adjective)
                    break
                }
            }
        }
    }

    func testGenerateAWord() {
        let expectedWord = "tinnitus"
        let testParameters = "?ml=ringing+in+the+ears&max=4"
        
        serviceManager.fetchWords(parameters: testParameters) {
            result in
            if let firstWord = result[0]["word"] as? String {
                XCTAssertEqual(firstWord, expectedWord)
            }
            XCTFail("Unexpected type")
        }
    }
    
    func testGenerateASetFirstLine() {
        let expectedLine = "bitter wintertime"
        let expectedNumberOfSyllabes = 5
        
        HaikuGenerator().generateFirstLine() { generatedLine in
            let generatedCount = Haiku.shared.firstLineSyllablesCount
            
            XCTAssertEqual(generatedLine, expectedLine)
            XCTAssertEqual(generatedCount, expectedNumberOfSyllabes)
        }
    }
}
