//
//  PotentialApp.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PotentialApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataController = DataController()
    @AppStorage("username") var username = "Elias Tabaka"
    @AppStorage("email") var email = "mmtabaka1@sheffield.ac.uk"
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView(name: $username, email: $email)
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }
                
                DeadlineView()
                    .tabItem {
                        Label("Deadlines", systemImage: "list.clipboard")
                    }
                
                AttendanceView()
                    .tabItem {
                        Label("Attendance", systemImage: "clock.badge.checkmark")
                    }
                
                GradeView()
                    .tabItem {
                        Label("Grades", systemImage: "percent")
                    }
                
                ModuleView(username: username, email: email)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tabItem {
                        Label("Groups", systemImage: "person.3.fill")
                    }
            }
        }
    }
}
