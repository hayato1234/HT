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
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let vocabCoreData = try? context.fetch(VocabCD.fetchRequest()) {
                if let vocabs = vocabCoreData as? [VocabCD]{
                    if vocabs.count == 0 {
                        // load from Firebase
                        print("Repo: loading from Firebase")
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

                                    let vocabToSave = VocabCD(context: context)
//                                    if let id = data["id"] as? String{
//                                        vocabToSave.id = id
//                                    }
                                    vocabToSave.id = document.documentID
                                    if let unit = data["unit"] as? Int16{
                                        vocabToSave.unit = unit
                                    }
                                    if let number = data["number"] as? Int16 {
                                        vocabToSave.number = number
                                    }
                                    if let word = data["word"] as? String{
                                        vocabToSave.word = word
                                    }
                                    if let parts = data["parts"] as? String{
                                        vocabToSave.parts = parts
                                    }
                                    if let noun = data["noun"] as? String{
                                        vocabToSave.noun = noun
                                    }
                                    if let itverb = data["itverb"] as? String{
                                        vocabToSave.itverb = itverb
                                    }
                                    if let tverb = data["tverb"] as? String{
                                        vocabToSave.tverb = tverb
                                    }
                                    if let adj = data["adj"] as? String {
                                        vocabToSave.adj = adj
                                    }
                                    if let adv = data["adv"] as? String {
                                        vocabToSave.adv = adv
                                    }
                                    if let prep = data["prep"] as? String {
                                        vocabToSave.prep = prep
                                    }
                                    if let conn = data["conn"] as? String {
                                        vocabToSave.conn = conn
                                    }
                                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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
                    }else{
                        //load from Core Data
                        print("Repo: loading from Core Data")
                        if let vocabCoreData = try? context.fetch(VocabCD.fetchRequest()) {
                            if let vocabs = vocabCoreData as? [VocabCD] {
                                
//                                deleteAllData(vocabs: vocabs)
                                //print("repo-loadall: delete complete \(vocabs[0].id)")
                                //print("repo-loadall: delete complete \(vocabs.count)")
                                for unitNum in 0..<units.count {
                                    //print("repo loadall: \(vocabTypeConverter(v: vocabs[0])?.word) ")
                                    let vocabInUnit = vocabs.filter{
                                        $0.unit == unitNum
                                    }
                                    for vocab in vocabInUnit {
                                        if let conVocav = vocabTypeConverter(v: vocab){
                                            self.units[unitNum].vocabData.append(conVocav)
                                        }
                                    }
                                }
                            }else{
                                print("repo loadall: not possible")
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func deleteAllData(vocabs: [VocabCD]) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            for vcb in vocabs {
                context.delete(vcb)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            print("repo-loadall: delete complete \(vocabs.count)")
        }
    }
    
    func vocabTypeConverter(v: VocabCD) -> Vocab? {
        
        //return Vocab(id: "", unit: 1, number: 1, word: "word", parts: "parts", noun: "noun", itverb: "itverb", tverb: "tverb", adj: "adj", adv: "adv", prep: "prep", conn: "conn")
//        if let id = v.id,
//           let word = v.word,
//           let parts = v.parts{
//            return Vocab(id: id, unit: Int(v.unit), number: Int(v.number), word: word, parts: parts, noun: "noun", itverb: "itverb", tverb: "tverb", adj: "adj", adv: "adv", prep: "prep", conn: "conn")
//        }
        if let id = v.id,
           let word = v.word,
           let parts = v.parts,
           let noun = v.noun,
           let itverb = v.itverb,
           let tverb = v.tverb,
           let adj = v.adj,
           let adv = v.adv,
           let prep = v.prep,
           let conn = v.conn{
            return Vocab(id: id, unit: Int(v.unit), number: Int(v.number), word: word, parts: parts, noun: noun, itverb: itverb, tverb: tverb, adj: adj, adv: adv, prep: prep, conn: conn)
        }
        return nil
    }
    
    
    func vocabTypesConverter(vs: [VocabCD]) -> [Vocab] {
        var vocabs:[Vocab] = []
        
        for v in vs {
            if let id = v.id,
               let word = v.word,
               let parts = v.parts,
               let noun = v.noun,
               let itverb = v.itverb,
               let tverb = v.tverb,
               let adj = v.adj,
               let adv = v.adv,
               let prep = v.prep,
               let conn = v.conn{
                vocabs.append(Vocab(id: id, unit: Int(v.unit), number: Int(v.number), word: word, parts: parts, noun: noun, itverb: itverb, tverb: tverb, adj: adj, adv: adv, prep: prep, conn: conn))
            }
        }
        return vocabs
    }
    
//    func saveToCoreData() {
//        //if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//        //let newVocab = VocabCD(context: context)
//
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//            let <#name#> = <#value#>
//
//        }
//    }
}
