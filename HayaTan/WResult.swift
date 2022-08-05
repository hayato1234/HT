//
//  WResult.swift
//  HayaTan
//
//  Created by Hayato Moritani on 10/20/21.
//

import SwiftUI

struct WResult: View {
    
    @Binding var isShowingResult: Bool
    @Binding var result: Result
    var answerVocab: Vocab
    var vocabRepo: VocabRepo
    var unit: Int
    
    
    var body: some View {
        VStack{
            Text("Word: \(result.question)")
            
            //Text("Your answer: \(result.userAnswer)")
            
            let userAnswerArray = result.userAnswer.components(separatedBy: ",")
            ForEach(userAnswerArray,id:\.self){ userAnswer in
                if !userAnswer.isEmpty{
                    HStack{
                        //this will only return true if one of the user anweres right, need to pass indivial answer.
                        if judgeUserAnswer(correct: vocabRepo.getWriteAnswers(word: answerVocab, unit: unit), userAnswer: userAnswer) {
                            Image(systemName: "circle").foregroundColor(.green)
                            Text(userAnswer).foregroundColor(.green)
                        }else{
                            Image(systemName: "multiply").foregroundColor(.red)
                            Text(userAnswer).foregroundColor(.red)
                        }
                    }
                }
            }
            
            Text("Other answers: \(result.correctAnswer)")
            
            //Text("other accepted answers")
            
            Button(action: {
                isShowingResult.toggle()
            }, label: {
                Text("OK")
            }).padding()
        }
    }
    
    
    func judgeUserAnswer(correct: [String:String], userAnswer: String) -> Bool {

        var isAnswerCorrect:Bool = false

        let answers = [String](correct.keys)

        
        if !userAnswer.isEmpty {
            for answer in answers {
                if let partAnswer = correct[answer] {
                    if partAnswer == userAnswer {
                        isAnswerCorrect = true
                    }
                    print("WRes-judge: \(partAnswer) =? \(userAnswer)")
                }
            }
        }
        

        return isAnswerCorrect
    }

    
    
//    //this func can judge whether if one of the answers is correct (multiple)
//    func judgeUserAnswers(correct: [String:String], userAnswers: [String]) -> Bool {
//
//        var containCorrectAnswer:Bool = false
//
//        let answers = [String](correct.keys)
//
//        for userAnswer in userAnswers{
//            if !userAnswer.isEmpty {
//                for answer in answers {
//                    if let partAnswer = correct[answer] {
//                        if partAnswer == userAnswer {
//                            containCorrectAnswer = true
//                        }
//                        print("WRes-judge: \(partAnswer) =? \(userAnswer)")
//                    }
//                }
//            }
//        }
//
//        return containCorrectAnswer
//    }
}

//struct WResult_Previews: PreviewProvider {
//    static var previews: some View {
//        WResult()
//    }
//}
