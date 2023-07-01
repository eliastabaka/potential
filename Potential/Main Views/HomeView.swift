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
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Grade average")
                        Spacer()
                        Text("\(String(format: "%.2f", gradeAverage()))%")
                    }
                    HStack {
                        Text("Attendance")
                        Spacer()
                        Text("89%")
                    }
                    
                    HStack {
                        Text("Assessments to complete")
                        Spacer()
                        Text("\(assessmentsToComplete())")
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
        let bigDifference: Double = Double(Calendar.current.dateComponents([.day], from: start, to: end ).day?.formatted() ?? "1.0") ?? 1.0
        let smallDifference: Double = Double(Calendar.current.dateComponents([.day], from: start, to: Date.now ).day?.formatted() ?? "1.0") ?? 1.0
        
        return (smallDifference / bigDifference) * 100
        
    }
    
    func assessmentsToComplete() -> Int {
        var counter = 0
        for assessment in assessments {
            if assessment.grade == 0 {
                counter += 1
            }
        }
        return counter
    }
    
    func gradeAverage() -> Double {
        var sum = 0.0
        for module in modules {
            for assessment in (assessments.filter { a in return module.code ?? "" == a.moduleCode ?? ""}) {
                sum += Double(assessment.grade) * Double(assessment.percentage) / 100.0 * Double(module.credits)
            }
        }
        
        return sum / 120.0
    }
}
