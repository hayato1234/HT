//
//  ResultPage.swift
//  HayaTan
//
//  Created by Hayato Moritani on 4/2/21.
//

import SwiftUI

struct ResultPage: View {
    @Binding var isShowingResult: Bool
    @Binding var results: [Result]
    
    var body: some View {
        VStack{
            Text("correct: "+String(countCorrect()))
            Text("wrong: "+String(countWrong()))
            List{
                ForEach(results){ result in
                    HStack{
                        if result.seikai {
                            Image(systemName: "circle")
                            Text(result.question).bold().foregroundColor(.green)
                        } else{
                            Image(systemName: "multiply")
                            Text(result.question).bold().foregroundColor(.red)
                        }
                        
                        Spacer()
                        VStack{
                            if !result.seikai{
                                Text(result.userAnswer).strikethrough()
                            }
                            Text(result.correctAnswer).border(Color.red)
                        }
                    }
                }
            }
            Button(action: {
                    results.removeAll()
                    self.isShowingResult = false}, label: {Text("もう一度")})
        }.padding(20)
    }
    
    func countCorrect() -> Int {
        var count = 0
        for result in results {
            if result.seikai {
                count+=1
            }
        }
        return count
    }
    func countWrong() -> Int {
        var count = 0
        for result in results {
            if !result.seikai {
                count+=1
            }
        }
        return count
    }
}

//struct ResultPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultPage(isShowingResult: .constant(true), results: [Result(id: "a", num: 1, quetion: "approximatley", correctAnswer: "およそ", userAnswer: "およそ", seikai: true, choices: ["およそ","ピッタリ"]),Result(id: "b", num: 2, quetion: "fold", correctAnswer: "をたたむ", userAnswer: "およそ", seikai: false, choices: ["およそ","ピッタリ"])])
//    }
//}
