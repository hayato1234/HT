//
//  VocabDetailView.swift
//  HayaTan
//
//  Created by Hayato Moritani on 5/24/21.
//

import SwiftUI

struct VocabDetailView: View {
    
    var vocab:Vocab
    var vocabRepo:VocabRepo
    
    
    var body: some View {
        VStack{
            
            Text("Unit: ")+Text(String(vocab.unit))
            Text("Number: ")+Text(String(vocab.number))
            Text(vocab.word).underline().font(.system(size: 40)).bold().frame(width: 400, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(vocabRepo.getYaku(word: vocab, unitNum: vocab.unit)).font(.system(size: 30)).fontWeight(.bold)
            
            //getSentence()
        }
    }
    
    func getSentence() -> Text{
        
        guard let keyLeftPos = vocab.conn.firstIndex(of: "["),
              let keyRightPos = vocab.conn.firstIndex(of: "]")
        else { return Text("") }
        let keyStart = vocab.conn.index(keyLeftPos, offsetBy: 1)
        let keyEnd = vocab.conn.index(keyRightPos, offsetBy: -2)
        let secondHalfStart = vocab.conn.index(keyRightPos, offsetBy: 1)
        
        let firstHalf = vocab.conn[..<keyLeftPos]
        let keyword = vocab.conn[keyStart..<keyEnd]
        let secondHalf = vocab.conn[secondHalfStart...]
        
        return Text(String(firstHalf))+Text(String(keyword)).bold().underline()+Text(String(secondHalf))
    }
}

struct VocabDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VocabDetailView(vocab: Vocab(id: "a", unit: 1, number: 1, word: "approximately", parts: "adv", noun: "", itverb: "", tverb: "", adj: "", adv: "約,およそ", prep: "", conn: ""),vocabRepo: VocabRepo())
    }
}
