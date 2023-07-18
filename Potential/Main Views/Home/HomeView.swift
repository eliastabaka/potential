//
//  HomeView.swift
//  Potential
//
//  Created by Elias Tabaka on 16/06/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var forceRedraw = ""
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
    
    let generalInfo = "You can add relevant modules and assessments in Settings. Remember to add all of the assessments for each module."
    let studyPartners = "Contact prospective study partners or add your name to the list in Student Space -> Study Partners"
    let learnGrades = "Update assessment grades in 'Grades' tab. You can estimate your future grades by clicking on the compass icon."
    let learnAttendance = "Add your entries in 'Attendance' tab"
    let learnSemesterDates = "Update your semester dates in Settings"
    let learnTrends = "View all trending topics in Student Space -> University Topics. Remember to refresh by swiping down."
    let learnDeadlines = "Add your deadlines in 'Deadlines' tab. After each working session you can update the time spent."
    
    let helpColor = Color.blue
    
    var body: some View {
        if !networkMonitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                Form {
                    Section {
                        if gettingStarted {
                            Text(generalInfo)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                    }
                    
                    Section {
                        if gettingStarted {
                            Text(studyPartners)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                    }

                    // Statistics
                    Section {
                        HStack {
                            Text("Grade average")
                            Spacer()
                            Text("\(String(format: "%.2f", gradeAverage()))%")
                        }
                        
                        HStack {
                            Text("Assessments to complete")
                            Spacer()
                            Text("\(assessmentsToComplete())")
                        }
                        
                        if gettingStarted {
                            Text(learnGrades)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                        
                        
                        HStack {
                            Text("Attendance")
                            Spacer()
                            Text("\(String(format: "%.2f", Attendance()))%")
                        }
                        if gettingStarted {
                            Text(learnAttendance)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                        
                        
                        
                        if !(yearCompletion().isNaN || yearCompletion().isInfinite) {
                            HStack {
                                Text("Academic year completed in")
                                Spacer()
                                Text("\(String(format: "%.2f", yearCompletion()))%")
                            }
                        }
                        if gettingStarted {
                            Text(learnSemesterDates)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                        
                    } header: {
                        Text("Statistics")
                    } footer: {
                        if yearCompletion().isNaN || yearCompletion().isInfinite {
                            Text("Semester dates are incorrect")
                                .foregroundColor(.red)
                        }
                    }
                
                    // Trending topics
                    Section {
                        if gettingStarted {
                            Text(learnTrends)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                        ForEach(upToThree(arr: topicsModel.topics)) { topic in
                            HStack {
                                Text(topic.title)
                                Spacer()
                                Text("\(topic.votes)")
                            }
                        }
                        
                    } header: {
                        Text("Trending topics")
                    } footer: {
                        Text("Swipe down to refresh")
                            .foregroundStyle(.blue)
                    }
                    .onChange(of: forceRedraw) { v in
                        topicsModel.getData()
                    }
                    
                    
                    // Deadlines
                    Section {
                        if gettingStarted {
                            Text(learnDeadlines)
                                .font(.footnote)
                                .foregroundStyle(helpColor)
                        }
                        ForEach(deadlines) { deadline in
                            HStack {
                                Text(deadline.name ?? "")
                                Spacer()
                                Text("\(Calendar.current.dateComponents([.day], from: Date.now, to: deadline.date ?? Date.now).day?.formatted() ?? "a") days left")
                            }
                        }
                    } header: {
                        Text(deadlines.isEmpty ? "Your deadlines will appear here" : "Deadlines")
                    }
                }
                
                .refreshable {
                    topicsModel.getData()
                    forceRedraw += "1"
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
        
        let calculation = (smallDifference / bigDifference) * 100
        return calculation > 100.0 ? 100.0 : calculation
        
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
    
    func upToThree(arr: [Topic]) -> [Topic] {
        var newArr = [Topic]()
        
        for i in 0..<3 {
            if i < arr.count {
                newArr.append(arr[i])
            }
        }
        return newArr
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
