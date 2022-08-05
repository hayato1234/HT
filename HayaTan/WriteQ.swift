//
//  WriteQ.swift
//  HayaTan
//
//  Created by Hayato Moritani on 10/8/21.
//

import SwiftUI

struct WriteQ: View {
    
    @Binding var isShowingWrite: Bool
    @State var isShowingResult: Bool = false
    var vocabRepo: VocabRepo
    var sortedVocabs: [Vocab]
    var unit: Int
    //@State var results:[Result] = []
    @State var result:Result = Result(id: "", num: 0, question: "", correctAnswer: "", userAnswer: "", seikai: false, choices: [])
    
    @State var questionNumber = 0
    @State var totalQNum = 20
    @State private var userAnswers:[String] = [String](repeating: "", count: 6)
    
    var body: some View {
        
        let currentVocabs = vocabRepo.units[unit].vocabData
        
        NavigationView{
            VStack{
                if let answerVocab = sortedVocabs[questionNumber]{
                    
                    HStack{
                        Spacer()
                        Text("\(questionNumber+1)/\(totalQNum)")
                    }
                    
                    //Question Word
                    Text("Q\(questionNumber+1) : \(answerVocab.word)").padding(.top, 30).font(.system(size: 40))
                    
                    //asnwer box for parts
                    
                    let seikai = vocabRepo.getWriteAnswers(word: answerVocab, unit: unit)
                    let answers = [String](seikai.keys)
                    
                    HStack{
                        Text("Hint: ")
                        ForEach(answers, id:\.self){ answer in
                            Text(answer+"  ")
                        }
                    }.padding()
                    
                    
//                    ForEach(answers, id:\.self){ answer in
//                        HStack{
//                            Text(answer+" : ")
//                            TextField("", text: $userAnswer)
//                        }.textFieldStyle(RoundedBorderTextFieldStyle()).padding(.all, 50)
//                    }
                    
                    ForEach(0..<userAnswers.count){ i in
                        let num = String(i+1)
                        if i == 0{
                            TextField("your answer "+num, text: $userAnswers[i]).textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .padding(.leading, 200)
                                .padding(.trailing, 200)
                        }else{
                            TextField("your answer "+num+" (optional)", text: $userAnswers[i]).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.all, 5)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .padding(.leading, 200)
                                .padding(.trailing, 200)
                        }
                    }
                    
                    Button(action: {
                        let userAnswer = userAnswers.joined(separator: ",")
                        result = Result(id: answerVocab.word, num: answerVocab.number, question: answerVocab.word, correctAnswer: vocabRepo.getYaku(word: answerVocab, unitNum: unit), userAnswer: userAnswer, seikai: false, choices: [])
                        //results.append(result)
                        userAnswers = [String](repeating: "", count: 6)
                        questionNumber+=1
                        
                        // this will change the answerVocab and everything is wrong in Result
                        
                        isShowingResult.toggle()
                        //print(result)
                    }, label: {Text("Check")})
                    .padding()
                    .sheet(isPresented: $isShowingResult){ // sheet for result
                        WResult(isShowingResult: $isShowingResult, result: $result, answerVocab: answerVocab, vocabRepo: vocabRepo, unit: unit)
                    }
                    
                    Button(action: {questionNumber+=1}, label: {
                        Text("Skip")
                    }).padding()
                }
                
            }
            .navigationBarTitle("書きクイズ", displayMode: .inline)
            .navigationBarItems(leading: Button{
                isShowingWrite = false
            } label: {
                Image(systemName: "arrow.backward").font(.headline)
            })
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}



//struct WriteQ_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteQ()
//    }
//}
