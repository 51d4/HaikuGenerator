//
//  HaikuGenerator.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import Foundation

class HaikuGenerator {
    private let serviceManager = ServiceManager()
    
    func generateFirstLine(completion: @escaping (_ firstLine: String) -> Void) {
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
}
