//
//  PaddingModifier.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-11-09.
//

import SwiftUI

public extension View {
    /// Applies padding to all or select edges specified number of times
    /// - parameter edges specifies the edges to which padding should be applied, defaults to `all`
    /// - parameter multiple specifies the number of times padding should be applied
    func padding(_ edges: Edge.Set = .all, multiple: Int) -> some View {
        modifier(DaisyPaddingModifier(edges: edges, multiple: multiple))
    }
}

private struct DaisyPaddingModifier: ViewModifier {
    
    let edges: Edge.Set
    let multiple: Int
    
    func body(content: Content) -> some View {
        buildView(content: content, edges, multiple: multiple)
    }
    
    @ViewBuilder private func buildView(content: Content, _ edges: Edge.Set, multiple: Int) -> some View {
        if multiple == 0 {
            content
        } else {
            content
                .padding(edges)
                .modifier(DaisyPaddingModifier(edges: edges, multiple: multiple - 1))
        }
    }
}

struct DaisyPaddingModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
            Text("Multiple 0")
                .background(Color.secondary)
                .padding(multiple: 0)
            Rectangle()
            Text("Multiple 1")
                .background(Color.secondary)
                .padding(multiple: 1)
            Rectangle()
            Text("Multiple 3")
                .background(Color.secondary)
                .padding(multiple: 3)
            Rectangle()
            Text("Multiple 6")
                .background(Color.secondary)
                .padding(multiple: 6)
            Rectangle()
        }
    }
}
