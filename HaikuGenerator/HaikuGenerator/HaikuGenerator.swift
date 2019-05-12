//
//  HaikuGenerator.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import Foundation

class HaikuGenerator {
    
    func generateFirstLine(completion: @escaping (_ firstLine: String) -> Void) {
        let serviceManager = ServiceManager()
        var firstNoun = ""
        serviceManager.fetchWords(parameters: "?ml=winter&md=s&max=4") { (result) in
            if let firstWord = result[0]["word"] as? String, let syllables = result[0]["numSyllables"] as? Int {
                print(firstNoun + " \(syllables)")
                Haiku.shared.firstLineSyllablesCount = syllables
                firstNoun = firstWord
                
                var firstAdjective = ""
                serviceManager.fetchWords(parameters: "?rel_jjb=\(firstNoun)&md=s&max=4") { (result) in
                    for dictionary in result {
                        if let adjective = dictionary["word"] as? String,
                            let syllables = dictionary["numSyllables"] as? Int,
                            syllables == 5 - Haiku.shared.firstLineSyllablesCount {
                            print(adjective + " \(syllables)")
                            
                            Haiku.shared.firstLineSyllablesCount = Haiku.shared.firstLineSyllablesCount + syllables
                            firstAdjective = adjective
                            completion(firstAdjective + " " + firstNoun)
                            break
                        }
                    }
                }
            }
        }
    }
}
