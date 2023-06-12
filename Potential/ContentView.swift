//
//  ContentView.swift
//  Potential
//
//  Created by Elias Tabaka on 12/06/2023.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var model = ViewModel()
    
    
    var body: some View {
        VStack {
            List (model.list) { item in
                Text(item.name)
                }
            }
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
