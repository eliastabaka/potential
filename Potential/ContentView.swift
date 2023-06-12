//
//  ContentView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var model = ViewModel()
    
    @State var code = ""
    @State var name = ""
    
    
    var body: some View {
        VStack {
            List (model.list) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    
//                    // Update button
//                    Button(action: {
//
//                        // Delete todo
//                        model.updateData(todoToUpdate: item)
//                    }, label: {
//                        Image(systemName: "pencil")
//                    })
//                    .buttonStyle(BorderlessButtonStyle())
                    
                    
                    // Delete button
                    Button(action: {
                        
                        // Delete todo
                        model.deleteData(moduleDelete:   item)
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
            }
        }
    
    Divider()
    
    VStack(spacing: 5) {
        TextField("Code", text: $code)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("Name", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button(action: {
            
            model.addData(code: code, name: name)
            
        }, label: {
            Text("Add Module")
        })
    }
    .padding()
}

init() {
    model.getData()
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
