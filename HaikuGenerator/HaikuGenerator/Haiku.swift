//
//  Haiku.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import Foundation

class Haiku {
    static let shared = Haiku()
    
    var firstLineNoun: String
    var firstLineAdjective: String
    var firstLineFirstPreposition: String?
    var firstLineSecondPreposition: String?
    var firstLineSyllablesCount: Int
    
    private init() {
        firstLineNoun = ""
        firstLineAdjective = ""
        firstLineSyllablesCount = 0
    }
}
