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
    var vocabRepo: VocabRepo
    var unit: Int
    
    var body: some View {
        
        let currentVocabs = vocabRepo.units[unit].vocabData
        
        NavigationView{
            VStack{
                if let randVocabs = currentVocabs.shuffled(){
                    if let answerVocab = randVocabs[questionNumber]{
                        //var answerWord: String = answerVocab.word
                        Text(answerVocab.word).padding(.all, 100)
                            .navigationBarTitle("選択クイズ", displayMode: .inline)
                            .navigationBarItems(leading: Button{
                                isShowingMult = false
                            } label: {
                                Image(systemName: "arrow.backward").font(.headline)
                            }, trailing: Button{
                                isShowingResult.toggle()
                            } label: {
                                Image(systemName: "checkmark").font(.headline)
                            })
                            .sheet(isPresented: $isShowingResult){
                                ResultPage(isShowingResult: $isShowingResult, results: results)
                            }
                        
                        if let choiceData = getChoices(choicesTotal: choiceNumber, correctVocab: answerVocab, vocabList: currentVocabs){
                            let choices = [String](choiceData.keys)
                            
                            ForEach(0..<4) { num in
                                let vocab = choices[num]
                                HStack{
                                    Text(vocab).padding(.all, 20).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }.padding(.leading, 20).onTapGesture {
                                    let resultData = Result(id: vocab, quetion: answerVocab.word, correctAnswer: vocabRepo.getYaku(word: answerVocab, unitNum: unit), userAnswer: vocab, seikai: choiceData[vocab] ?? true, choices: choices)
                                    results.append(resultData)
                                    questionNumber+=1
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
}

//struct MultipleQ_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleQ(isShowingMult: .constant(true),vocabRepo: VocabRepo())
//    }
//}
