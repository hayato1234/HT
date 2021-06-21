//
//  Result.swift
//  HayaTan
//
//  Created by Hayato Moritani on 4/2/21.
//

import Foundation

struct Result:Identifiable {
    var id: String
    let num: Int
    let quetion: String
    let correctAnswer: String
    let userAnswer: String
    let seikai: Bool
    let choices: [String]
}
