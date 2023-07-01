//
//  HomeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSettings = false
    @Binding var name: String
    @Binding var email: String
    @Binding var startDateStorage: String
    @Binding var endDateStorage: String
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var deadlines: FetchedResults<Deadline>
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Grade average")
                        Spacer()
                        Text("55.5%")
                    }
                    HStack {
                        Text("Attendance")
                        Spacer()
                        Text("89%")
                    }
                    
                    HStack {
                        Text("Assessments to complete")
                        Spacer()
                        Text("6")
                    }
                    
                    HStack {
                        Text("Academic year completed in")
                        Spacer()
                        Text("\(String(format: "%.2f", yearCompletion()))%")
                    }
                } header: {
                    Text("Statistics")
                }
                
                Section {
                    HStack {
                        Text("Your name is visible in")
                        Spacer()
                        Text("4 modules")
                    }
                } header: {
                    Text("Visibility")
                }
                
                Section {
                    ForEach(deadlines) { deadline in
                        HStack {
                            Text(deadline.name ?? "")
                                .foregroundColor(.primary)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(Calendar.current.dateComponents([.day], from: Date.now, to: deadline.date ?? Date.now).day?.formatted() ?? "a") days left")
                        }
                    }
                } header: {
                    Text("Deadlines")
                }
            }
            .navigationTitle("Potential")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(name: $name, email: $email, startDateStorage: $startDateStorage, endDateStorage: $endDateStorage)
            }
        }
    }
    
    func yearCompletion() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let start = dateFormatter.date(from: startDateStorage) ?? Date.now
        let end = dateFormatter.date(from: endDateStorage) ?? Date.now
        let today = Date.now
        let bigDifference: Double = Double(Calendar.current.dateComponents([.day], from: start, to: end ).day?.formatted() ?? "1.0") ?? 1.0
        let smallDifference: Double = Double(Calendar.current.dateComponents([.day], from: start, to: Date.now ).day?.formatted() ?? "1.0") ?? 1.0
        
        return (smallDifference / bigDifference) * 100
        
    }
}
