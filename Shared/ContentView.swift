//
//  ContentView.swift
//  Shared
//
//  Created by Maria Civilis on 2022-07-15.
//

import SwiftUI

struct ContentView: View {
    var daisies: [Daisy]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(daisies, id: \.id) {
                    Text("\($0.title)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(daisies: Daisy.previewMany)
    }
}
