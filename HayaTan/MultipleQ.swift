//
//  MultipleQ.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/31/21.
//

import SwiftUI

struct MultipleQ: View {
    @Binding var isShowingMult: Bool
    @State var isShowingResult = false
    @State var choiceNumber = 4
    @State var results:[Result] = []
    @State var randomizedVocabs:[Vocab] = []
    @State var questionNumber = 0
    @State var totalQNum = 20
    var vocabRepo: VocabRepo
    var unit: Int
    
    var body: some View {
        
        let currentVocabs = vocabRepo.units[unit].vocabData
        
        NavigationView{
            VStack{
                if let randVocabs = currentVocabs.shuffled(){
                    if let answerVocab = randVocabs[questionNumber]{
                        HStack{
                            Spacer()
                            Text("\(questionNumber+1)/\(totalQNum)").padding()
                        }
                        
                        //making question
                        Text("Q\(questionNumber+1) : \(answerVocab.word)").padding(.all, 100)
                            .navigationBarTitle("選択クイズ", displayMode: .inline)
                            .navigationBarItems(leading: Button{
                                isShowingMult = false
                            } label: {
                                Image(systemName: "arrow.backward").font(.headline)
                            }, trailing: Button{
                                // showing when check button clicked
                                saveWrongVocabs(results: results)
                                isShowingResult.toggle()
                            } label: {
                                Image(systemName: "checkmark").font(.headline)
                            })
                            .sheet(isPresented: $isShowingResult){
                                ResultPage(isShowingResult: $isShowingResult, results: results)
                            }
                        
                        //making choices and handling choice selction
                        if let choiceData = getChoices(choicesTotal: choiceNumber, correctVocab: answerVocab, vocabList: currentVocabs){
                            let choices = [String](choiceData.keys)
                            
                            ForEach(0..<4) { num in
                                let vocab = choices[num]
                                HStack{
                                    Text(vocab).padding(.all, 20).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }.padding(.leading, 20).onTapGesture {
                                    let resultData = Result(id: vocab, num: answerVocab.number, quetion: answerVocab.word, correctAnswer: vocabRepo.getYaku(word: answerVocab, unitNum: unit), userAnswer: vocab, seikai: choiceData[vocab] ?? true, choices: choices)
                                    results.append(resultData)
                                    questionNumber+=1
                                    if questionNumber+1 == totalQNum{
                                        saveWrongVocabs(results: results)
                                        isShowingResult.toggle()
                                    }
                                    //print(resultData)
                                }
                            }
                        }
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
    func getChoices(choicesTotal: Int, correctVocab: Vocab, vocabList: [Vocab]) -> [String : Bool] {
        var choices = [String : Bool]()
        
        let answer = vocabRepo.getYaku(word: correctVocab, unitNum: unit)
        choices[answer] = true
        
        var iteration = choicesTotal-1
        while iteration != 0 {
            let wrong = vocabRepo.getYaku(word: vocabList.randomElement()!,unitNum: unit)
            if [String](choices.keys).contains(wrong) {
                //do nothing
            }else{
                choices[wrong] = false
                iteration-=1
            }
        }
        //print(choices)
        
        return choices
    }
    
    func saveWrongVocabs(results: [Result]) {
        var numList = ""
        
        for i in 0..<results.count{
            if !results[i].seikai {
                if numList.isEmpty{
                    numList.append(String(results[i].num))
                }else{
                    //numList.append(", ")
                    numList.append(", "+String(results[i].num))
                }
            }
        }
        
        vocabRepo.updateUserVocabData(unit: unit, nums: numList)
    }
    
}

//struct MultipleQ_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleQ(isShowingMult: .constant(true),vocabRepo: VocabRepo())
//    }
//}
