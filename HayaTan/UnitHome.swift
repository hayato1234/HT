//
//  UnitHome.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/30/21.
//

import SwiftUI

struct UnitHome: View {
    
    @State var isShowingMult = false
    @State var isShowingWrite = false
    @State private var isHissuMode = false
    @State private var langSelect = 0
    @State var currentWord = 0

    @State var currentVocabs: [Vocab]
    @State var sortedByNumVocabs: [Vocab]
    var unitTitle: String
    var unit: Int
    var vocabRepo:VocabRepo

    var language = ["EN -> 日","日 -> EN"]

    init(_ unitTitle: String, _ unit: Int, _ vocabRepo: VocabRepo) {
        self.unitTitle = unitTitle
        self.unit = unit
        self.vocabRepo = vocabRepo

        currentVocabs = vocabRepo.units[unit].vocabData.shuffled()
        sortedByNumVocabs = vocabRepo.units[unit].vocabData.sorted(by: {
            $0.number < $1.number
        })

    }
    
    var body: some View {
        if currentVocabs.count == 0 {
            Text("No data found")
        }else{
            if isShowingMult {
                MultipleQ(isShowingMult: $isShowingMult, vocabRepo: vocabRepo, sortedVocabs: insertMissedBeginning(), unit: unit)
            } else if isShowingWrite {
                WriteQ(isShowingWrite: $isShowingWrite, vocabRepo: vocabRepo, sortedVocabs: insertMissedBeginning(), unit: unit)
            }else{
                VStack{
                    HStack{ // for hissu toggle
                        Spacer()
                        HStack{
                            //Spacer()
                            Text("必須モード")
                            Toggle("", isOn: $isHissuMode).onChange(of: isHissuMode){ isHissu in
                                if isHissu {
                                    currentVocabs = vocabRepo.vocabs1H.shuffled()
                                    sortedByNumVocabs = vocabRepo.vocabs1H.sorted(by: {
                                        $0.number < $1.number
                                    })
                                    //print("UniHome body: \(sortedByNumVocabs.count)")
                                } else {
                                    currentVocabs = vocabRepo.units[unit].vocabData.shuffled()
                                    sortedByNumVocabs = vocabRepo.units[unit].vocabData.sorted(by: {
                                        $0.number < $1.number
                                    })
                                }
                            }.labelsHidden()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                //.foregroundColor(isSoundOn ? .green : .gray)
                        )
                    }

                    HStack{
                        if currentWord == 0 {
                            HStack{
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
//
//
                    HStack{
                        Button(action: {isShowingMult.toggle()}, label: {
                            Text("選択")
                        }).font(.system(size: 50)).padding()
                        Button(action: {isShowingWrite.toggle()}, label: {
                            Text("書き").strikethrough()
                        }).font(.system(size: 50)).padding()
                        Button(action: {}, label: {
                            Text("テスト").strikethrough()
                        }).font(.system(size: 50)).padding()
                        Button(action: {}, label: {
                            Text("集中").strikethrough()
                        }).font(.system(size: 50)).padding()
                        //品詞別
                    }
//
//////                    Button(action: {  // for uploadling vocab list
//////                        initLoad()
//////                    }, label: {
//////                        Text("Upload")
//////                    }) // don't forget to change database name
//////                    Text("count is "+String(currentVocabs.count))
////
//////                    Button(action: {  // for uploading example sentence
//////                        vocabRepo.updateVocab(field: "sentence", value: "The new efficient software helped the company to reduce [approximately] $240,000 in the expenses.")
//////                    }, label: {
//////                        Text("update")
//////                    }) // don't forget to change database name
////
//
                    List{
                        ForEach(sortedByNumVocabs){ vocab in

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

    func insertMissedBeginning() -> [Vocab] {
        var randomVocabs = vocabRepo.units[unit].vocabData.shuffled()
        let missedString = vocabRepo.userMissedVocabs[unit]
        //print("home1 \(missedString)")
        let missedArray = vocabRepo.stringListToArray(value: missedString)
        //print("home2 \(missedArray)")
        var count = 0
        for missed in missedArray{
            if let index = randomVocabs.firstIndex(where: {String($0.number) == missed}){
                let removedVocab = randomVocabs.remove(at: index)
                randomVocabs.insert(removedVocab, at: count)
                //print("mulQinsert \(newRdmVocab[count].number)")
                count+=1
            }
        }
        count = 0

        return randomVocabs
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
