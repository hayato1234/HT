//
//  ResultPage.swift
//  HayaTan
//
//  Created by Hayato Moritani on 4/2/21.
//

import SwiftUI

struct ResultPage: View {
    @Binding var isShowingResult: Bool
    var results: [Result]
    
    var body: some View {
        VStack{
            Text("correct: "+String(countCorrect()))
            Text("wrong: "+String(countWrong()))
        }
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
//        ResultPage(isShowingResult: .constant(true),)
//    }
//}
