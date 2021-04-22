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
    
    var body: some View {
        HomeScreen()
//        VStack{
//            if user != nil {
//                HomeScreen()
//            }else{
//                LoginScreen()
//            }
//        }.onAppear(perform: {
//            NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
//                self.user = Auth.auth().currentUser
//            }
//        })
    }
}

struct HomeScreen: View {
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
