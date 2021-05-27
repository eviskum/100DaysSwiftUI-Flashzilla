//
//  Card.swift
//  Flashzilla
//
//  Created by Esben Viskum on 26/05/2021.
//

import Foundation

struct Card: Codable {
//    let id: UUID
    let prompt: String
    let answer: String
    
    init(prompt: String, answer: String) {
//        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
    
    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
