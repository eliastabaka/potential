//
//  NoConnectionView.swift
//  Potential
//
//  Created by Elias Tabaka on 18/07/2023.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        Text("No Internet Connection ") + Text(Image(systemName: "wifi.slash"))
    }
}

struct NoConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoConnectionView()
    }
}
