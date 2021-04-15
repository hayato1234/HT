//
//  VocabRepo.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/31/21.
//

import Foundation
import Firebase

class VocabRepo: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var units: [Unit] = []
    
    var vocabs0: [Vocab] = []
    var vocabs1: [Vocab] = []
    var vocabs2: [Vocab] = []
    var vocabs3: [Vocab] = []
    var vocabs4: [Vocab] = []
    var vocabs5: [Vocab] = []
    
    init() {
        units = [
            Unit(id: 0, unitName: "Unit 0", dbName: "super_vocabs_0",vocabData: vocabs0),
            Unit(id: 1, unitName: "Unit 1", dbName: "super_vocabs_1",vocabData: vocabs1),
            Unit(id: 2, unitName: "Unit 2", dbName: "super_vocabs_2",vocabData: vocabs2),
            Unit(id: 3, unitName: "Unit 3", dbName: "super_vocabs_3",vocabData: vocabs3),
            Unit(id: 4, unitName: "Unit 4", dbName: "super_vocabs_4",vocabData: vocabs4),
            Unit(id: 5, unitName: "Unit 5", dbName: "super_vocabs_5",vocabData: vocabs5)]
        
        loadAll()
    }
    
    func uploadVocab(vocab: Vocab) {
        db.collection(units[5].dbName).addDocument(data: [
            "unit": vocab.unit,
            "number": vocab.number,
            "word": vocab.word,
            "parts": vocab.parts,
            "noun": vocab.noun,
            "itverb": vocab.itverb,
            "tverb": vocab.tverb,
            "adj": vocab.adj,
            "adv": vocab.adv,
            "prep": vocab.prep,
            "conn": vocab.conn
        ])
    }
    
    func getYaku(word: Vocab, unitNum: Int) -> String {
        var yaku:String = ""
        if !word.noun.isEmpty  {
            yaku.append("名："+word.noun)
        }
        if unitNum == 0 {
            if !word.itverb.isEmpty {
                if yaku.count > 0 {
                    yaku.append("\n動："+word.itverb)
                    if !word.tverb.isEmpty {
                        yaku.append(", "+word.tverb)
                    }
                }else{
                    yaku.append("動："+word.itverb)
                    if !word.tverb.isEmpty {
                        yaku.append(", "+word.tverb)
                    }
                }
            } else if !word.tverb.isEmpty {
                if yaku.count > 0 {
                    yaku.append("\n動："+word.tverb)
                }else{
                    yaku.append("動："+word.tverb)
                }
            }
        }else{
            if !word.itverb.isEmpty {
                if yaku.count > 0 {
                    yaku.append("\n自動："+word.itverb)
                }else{
                    yaku.append("自動："+word.itverb)
                }
            }
            if !word.tverb.isEmpty {
                if yaku.count > 0 {
                    yaku.append("\n他動："+word.tverb)
                }else{
                    yaku.append("他動："+word.tverb)
                }
            }
        }
        
        if !word.adj.isEmpty {
            if yaku.count > 0 {
                yaku.append("\n形："+word.adj)
            }else{
                yaku.append("形："+word.adj)
            }
            
        }
        if !word.adv.isEmpty {
            if yaku.count > 0 {
                yaku.append("\n副："+word.adv)
            }else{
                yaku.append("副："+word.adv)
            }
            
        }
        if !word.prep.isEmpty {
            if yaku.count > 0 {
                yaku.append("\n前："+word.prep)
            }else{
                yaku.append("前："+word.prep)
            }
            
        }
        if !word.conn.isEmpty {
            if yaku.count > 0 {
                yaku.append("\n接："+word.conn)
            }else{
                yaku.append("接："+word.conn)
            }
        }
        return yaku
    }
    
    private func loadAll(){
        
        //let vocabLists = [ self.vocabs0, self.vocabs1, self.vocabs2, self.vocabs3, self.vocabs4, self.vocabs5]
        for i in 0..<6 {
            db.collection(units[i].dbName).getDocuments{ (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }
                guard let documents = snapshot?.documents else {print("error at snapshot");return}
                self.units[i].vocabData = documents.compactMap{document in
                    let data = document.data()
                    //print(data)
                    guard let unit = data["unit"] as? Int,
                          let number = data["number"] as? Int,
                          let word = data["word"] as? String,
                          let parts = data["parts"] as? String,
                          let noun = data["noun"] as? String,
                          let itverb = data["itverb"] as? String,
                          let tverb = data["tverb"] as? String,
                          let adj = data["adj"] as? String,
                          let adv = data["adv"] as? String,
                          let prep = data["prep"] as? String,
                          let conn = data["conn"] as? String else {return nil}
                    
                    return Vocab(id: document.documentID, unit: unit, number: number, word: word, parts: parts, noun: noun, itverb: itverb, tverb: tverb, adj: adj, adv: adv, prep: prep, conn: conn)
                }
            }
        }
        
//        db.collection(units[0].dbName).getDocuments{ (snapshot, error) in
//            if let error = error{
//                print(error)
//                return
//            }
//            guard let documents = snapshot?.documents else {print("error at snapshot");return}
//            self.vocabs0 = documents.compactMap{document in
//                let data = document.data()
//                //print(data)
//                guard let unit = data["unit"] as? Int,
//                      let number = data["number"] as? Int,
//                      let word = data["word"] as? String,
//                      let parts = data["parts"] as? String,
//                      let noun = data["noun"] as? String,
//                      let itverb = data["itverb"] as? String,
//                      let tverb = data["tverb"] as? String,
//                      let adj = data["adj"] as? String,
//                      let adv = data["adv"] as? String,
//                      let prep = data["prep"] as? String,
//                      let conn = data["conn"] as? String else {return nil}
//
//                return Vocab(id: document.documentID, unit: unit, number: number, word: word, parts: parts, noun: noun, itverb: itverb, tverb: tverb, adj: adj, adv: adv, prep: prep, conn: conn)
//            }
//        }
        
        //print(vocabs[0])
    }
}
