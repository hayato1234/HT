//
//  ContentView.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vocabRepo:VocabRepo = VocabRepo()
       
    var body: some View {
        NavigationView{
            List(vocabRepo.units, id:\.id){ (unit) in
                NavigationLink(
                    destination: UnitHome(unit.unitName, unit.id, vocabRepo),
                    label: {
                        Text(unit.unitName)
                    })
            }.navigationTitle("Choose a unit")
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
