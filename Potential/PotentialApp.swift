//
//  PotentialApp.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//


import SwiftUI
import FirebaseCore
import Foundation

// Firebase configuration
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct PotentialApp: App {
    
    // Databases configuration
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataController = DataController()
    
    @AppStorage("username") var studentName = "Elias Tabaka"
    @AppStorage("email") var studentEmailAddress = "mmtabaka1@sheffield.ac.uk"
    @AppStorage("startDate") var startDateStorage = DateFormatter().string(from: Date.now)
    @AppStorage("endDate") var endDateStorage = DateFormatter().string(from: Date.now)
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(name: $studentName, email: $studentEmailAddress, startDateStorage: $startDateStorage, endDateStorage: $endDateStorage)
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
                
                ModuleView(username: $studentName, email: $studentEmailAddress)
                    .tabItem {
                        Label("Groups", systemImage: "person.3.fill")
                    }
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            
        }
    }
}
