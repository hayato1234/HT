//
//  UnitHome.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/30/21.
//

import SwiftUI

struct UnitHome: View {
    
    @State var isShowingMult = false
    @State private var langSelect = 0
    @State var currentWord = 0
    var currentVocabs: [Vocab]
    var sortedByNumVocabs: [Vocab]
    var unitTitle: String
    var unit: Int
    var vocabRepo:VocabRepo
    
    var language = ["EN -> 日","日 -> EN"]

    init(_ unitTitle: String, _ unit: Int, _ vocabRepo: VocabRepo) {
        self.unitTitle = unitTitle
        self.unit = unit
        self.vocabRepo = vocabRepo
        currentVocabs = vocabRepo.units[unit].vocabData.shuffled()
        sortedByNumVocabs = currentVocabs.sorted(by: {
            $0.number < $1.number
        })
    }
    
    var body: some View {
        if currentVocabs.count == 0 {
            Text("No data found")
            
        }else{
            if isShowingMult {
                MultipleQ(isShowingMult: $isShowingMult, vocabRepo: vocabRepo, unit: unit)
            }else{
                VStack{
                    HStack{
                        
                        if currentWord == 0 {
                            HStack{
                                //Image(systemName: "chevron.backward")
                                
                                Text(unitTitle).font(.system(size: 30)).fontWeight(.bold).frame(width: 300, height: 300, alignment: .center)
                                Image(systemName: "circle").background(Color.white).clipShape(Circle())
                            }.background(Color.yellow).offset(x: 20, y: 0)
                        }else{
                            HStack{
                                Image(systemName: "chevron.backward")
                                VStack{
                                    if langSelect == 0{
                                        Text(currentVocabs[currentWord-1].word)
                                        Text(vocabRepo.getYaku(word: currentVocabs[currentWord-1], unitNum: unit)).font(.system(size: 20)).fontWeight(.bold)
                                    }else{
                                        Text(currentVocabs[currentWord-1].word).font(.system(size: 20)).fontWeight(.bold)
                                        Text(vocabRepo.getYaku(word: currentVocabs[currentWord-1], unitNum: unit))
                                    }
                                }.frame(width: 300, height: 300)
                                Image(systemName: "circle")
                            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/).onTapGesture {
                                //print()
                                currentWord-=1
                            }.offset(x: 20, y: 0)
                        }
                        Image(systemName: "circle").resizable().frame(width: 30, height: 25)
                        HStack{
                            Image(systemName: "circle")
                            if langSelect == 0{
                                Text(currentVocabs[currentWord].word).font(.system(size: 30)).fontWeight(.bold).frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }else{
                                Text(vocabRepo.getYaku(word: currentVocabs[currentWord], unitNum: unit)).font(.system(size: 25)).fontWeight(.bold).frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }
                            
                            Image(systemName: "chevron.forward")
                        }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/).onTapGesture {
                            //print(currentVocabs[0].word+", "+currentVocabs[1].word+", "+currentVocabs[2].word)
                            currentWord+=1
                        }.offset(x: -20, y: 0)
                    }
                    Picker("",selection: $langSelect){
                        ForEach(0 ..< language.count){
                            Text(self.language[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle()).frame(width: 200).padding()
                    
                    Text(String(langSelect))
                    
                    HStack{
                        Button(action: {isShowingMult.toggle()}, label: {
                            Text("選択")
                        }).font(.system(size: 50)).padding()
                        Button(action: {isShowingMult.toggle()}, label: {
                            Text("書き")
                        }).font(.system(size: 50)).padding()
                        Button(action: {isShowingMult.toggle()}, label: {
                            Text("テスト")
                        }).font(.system(size: 50)).padding()
                        Button(action: {isShowingMult.toggle()}, label: {
                            Text("集中")
                        }).font(.system(size: 50)).padding()
                        //品詞別
                    }
                    
//                    Button(action: {
//                        initLoad()
//                    }, label: {
//                        Text("Upload")
//                    }) // don't forget to change database name
//                    Text("count is "+String(currentVocabs.count))
                    
                    Button(action: {
                        vocabRepo.updateVocab(field: "sentence", value: "The new efficient software helped the company to reduce [approximately] $240,000 in the expenses.")
                    }, label: {
                        Text("update")
                    }) // don't forget to change database name
                    
                
                    HStack{
                        Text("Mode 必須")
                    }
                 
                    List{
                        ForEach(sortedByNumVocabs){ vocab in
                            
//                            NavigationLink(
//                                destination: UnitHome(unit.unitName, unit.id, vocabRepo),
//                                label: {
//                                    Text(unit.unitName)
//                                })
                            NavigationLink(destination: VocabDetailView(vocab: vocab,vocabRepo: vocabRepo),label:{
                                HStack{
                                    Text(String(vocab.number))
                                    Text(vocab.word)
                                }
                            })
                        }
                    }
                }.navigationBarTitle(unitTitle,displayMode: .inline)
            }
        }
    }

    func initLoad() {
        if let path = Bundle.main.path(forResource: "unit5", ofType: "json"){
            do{
                print("doing")
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any]{
                    for vocabData in jsonResult {
                        if let vocabToUpload = vocabData as?[String: Any]{
                            if let vocabObj = createVocab(vocabData: vocabToUpload){
                                //print(vocabObj.word)
                                vocabRepo.uploadVocab(vocab: vocabObj)
                            }
                        }
                    }
                    print("upload complete")
                }else{
                    print("result fail")
                }
            }catch{
                print("error")
            }
        }else{
            print("file not found")
        }
    }

    func createVocab(vocabData: [String: Any]) -> Vocab? {
        if let unit = vocabData["unit"] as? Int,
           let num = vocabData["num"] as? Int,
           let word = vocabData["en"] as? String,
           let parts = vocabData["parts"] as? String,
           let noun = vocabData["noun"] as? String,
           let itverb = vocabData["itverb"] as? String,
           let tverb = vocabData["tverb"] as? String,
           let adj = vocabData["adj"] as? String,
           let adv = vocabData["adv"] as? String,
           let prep = vocabData["prep"] as? String,
           let conn = vocabData["conn"] as? String{
           let vocab = Vocab(id: "", unit: unit, number: num, word: word, parts: parts, noun: noun, itverb: itverb, tverb: tverb, adj: adj, adv: adv, prep: prep, conn: conn)
            return vocab
        }
        //let error = "error"
        return nil
        //return Vocab(id: error, unit: 6, number: 0, word: error, parts: error, noun: error, itverb: error, tverb: error, adj: error, adv: error, prep: error, conn: error)
    }
}

//struct UnitHome_Previews: PreviewProvider {
//    static var previews: some View {
//        UnitHome(unitTitle: "", vocabRepo: VocabRepo())
//    }
//}
