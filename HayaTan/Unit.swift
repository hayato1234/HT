//
//  Unit.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/30/21.
//

import Foundation

struct Unit: Identifiable {
    var id: Int
    var unitName: String
    var dbName: String
    var vocabData: [Vocab]
}
