//
//  TO_Childcare_FinderApp.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-07.
//

import SwiftUI

import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()
      
      if let app = FirebaseApp.app(){
          print("Firebase initialized with name: \(app.name)")
      }else{
          print("Firebase not initialized")
      }
      
    return true

  }

}


@main

struct TO_Childcare_FinderApp: App {

    
  // register app delegate for Firebase setup

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataManager = DataManager()


  var body: some Scene {

    WindowGroup {

      NavigationView {

        ContentView()
              .environmentObject(dataManager)

      }

    }

  }

}
