//
//  ContentView.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/29/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
       
    @State var user = Auth.auth().currentUser
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \VocabCD.id, ascending: false)]) private var localVocab: FetchedResults<VocabCD>
    
    var body: some View {
        VStack{
            if user != nil {
                HomeScreen()
            }else{
                LoginScreen()
            }
        }.onAppear(perform: {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
                self.user = Auth.auth().currentUser
                
            }
        })
    }
    
}

struct HomeScreen: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \VocabCD.id, ascending: false)]) private var localVocab: FetchedResults<VocabCD>
    @ObservedObject var vocabRepo:VocabRepo = VocabRepo()
    
    
//    init() {
////        if localVocab.isEmpty{
////            vocabRepo = VocabRepo()
////            print("trying initial load")
////            for unit in vocabRepo.units {
////                for vocab in unit.vocabData {
////                    let addVocab = VocabCD(context: viewContext)
////                    addVocab.id = vocab.id
////                    addVocab.unit = Int16(vocab.unit)
////                    addVocab.number = Int16(vocab.number)
////                    addVocab.word = vocab.word
////                    addVocab.parts = vocab.parts
////                    addVocab.noun = vocab.noun
////                    addVocab.itverb = vocab.itverb
////                    addVocab.tverb = vocab.tverb
////                    addVocab.adj = vocab.adj
////                    addVocab.prep = vocab.prep
////                    addVocab.conn = vocab.conn
////                    do{
////                        try viewContext.save()
////                    }catch{
////                        let error = error as NSError
////                        fatalError("ConView: \(error)")
////                    }
////                }
////            }
////        }
////        print(localVocab.count)
//
//    }
    
    var body: some View {
        NavigationView{
            List(vocabRepo.units, id:\.id){ (unit) in
                NavigationLink(
                    destination: UnitHome(unit.unitName, unit.id, vocabRepo),
                    label: {
                        Text(unit.unitName)
                    })
            }.navigationTitle("Choose a unit")
            .navigationBarItems(trailing: Button(action: {signout()}, label: {
                Text("signout")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

struct LoginScreen: View {
    var body: some View {
        Button(action: {GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                GIDSignIn.sharedInstance()?.signIn()}, label: {
            Image("btn_google_signin_dark_normal_web-1")
        })
    }
}

func signout() {
    GIDSignIn.sharedInstance()?.signOut()
    do{
        try Auth.auth().signOut()
    } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
