//
//  HomeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showingSettings = false
    @State private var gettingStarted = false
    @Binding var name: String
    @Binding var email: String
    @Binding var startDateStorage: String
    @Binding var endDateStorage: String
    @ObservedObject var topicsModel = DepartmentTopics()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var deadlines: FetchedResults<Deadline>
    @FetchRequest(sortDescriptors: []) var assessments: FetchedResults<Assessment>
    @FetchRequest(sortDescriptors: []) var modules: FetchedResults<Module>
    @FetchRequest(sortDescriptors: []) var attendanceEntries: FetchedResults<Attendance>
    
    var body: some View {
        NavigationView {
            Form {
                if gettingStarted {
                    Section{
                        Text("Add all of your modules in Settings -> Modules")
                            .font(.footnote)
                            .foregroundColor(networkMonitor.isConnected ? .green : .red)
                        Text("For each module add relevant assessments")
                            .font(.footnote)
                        Text("Keep track of your attendance in Attendance tab")
                            .font(.footnote)
                        Text("Keep track of your grades in Grades tab")
                            .font(.footnote)
                        Text("Find study partners and engage in university life in Student Space")
                            .font(.footnote)
                        
                        
                    } header: {
                        Text("Getting started")
                    }
                }
                
                
                Section {
                    HStack {
                        Text("Grade average")
                        Spacer()
                        Text("\(String(format: "%.2f", gradeAverage()))%")
                    }
                    HStack {
                        Text("Attendance")
                        Spacer()
                        Text("\(String(format: "%.2f", Attendance()))%")
                    }
                    
                    HStack {
                        Text("Assessments to complete")
                        Spacer()
                        Text("\(assessmentsToComplete())")
                    }
                    if yearCompletion().isNaN || yearCompletion().isInfinite {
                        
                        
                        Text("Semester dates not specified.")
                            .foregroundColor(.red)
                    } else {
                        HStack {
                            Text("Academic year completed in")
                            Spacer()
                            Text("\(String(format: "%.2f", yearCompletion()))%")
                        }
                    }
                } header: {
                    Text("Statistics")
                }
                
                Section {
                    ForEach(0..<3) { index in
                        HStack {
                            if index < topicsModel.topics.count {
                                Text(topicsModel.topics[index].title)
                                Spacer()
                                Text("\(topicsModel.topics[index].votes)")
                            }
                        }
                    }
                } header: {
                    Text("Trending topics")
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
                    Text(deadlines.isEmpty ? "Your deadlines will appear here" : "Deadlines")
                }
            }
            .onAppear() {
                topicsModel.getData()
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation() {
                            gettingStarted.toggle()
                        }
                    } label: {
                        Label("Hints", systemImage: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(name: $name, email: $email, startDateStorage: $startDateStorage, endDateStorage: $endDateStorage)
            }
            .refreshable {
                topicsModel.getData()
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
    
    func Attendance() -> Double {
        var attendedSum = 0.0
        for i in attendanceEntries {
            if i.attended {
                attendedSum += 1.0
            }
        }
        if attendanceEntries.count == 0 {
            return 0.0
        }
        
        return attendedSum * 100 / Double(attendanceEntries.count)
    }
}
