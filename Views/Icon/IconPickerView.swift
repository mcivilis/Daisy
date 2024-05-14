//
//  IconPickerView.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-09-20.
//

import SwiftUI

struct IconPickerView: View {
    
    @Environment(\.dismiss) var dismiss // TODO: Do i need this?
    
    let color: Color
    @Binding public var icon: Icon
    @State private var searchText = ""
    
    private var filtred: [String] {
        if searchText.isEmpty {
            return Symbols.all
        } else {
            return Symbols.all.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private let columns = [GridItem(.adaptive(minimum: 50))]
    
    @ViewBuilder
    private var symbolSelectionView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filtred, id: \.self) { symbol in
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: icon.value == symbol ? 2 : 0)
                        .background(icon.value == symbol ? Color.accentColor : Color.clear)
                        .shadow(radius: 3)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: symbol)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        }
                        .onTapGesture {
                            icon = Icon(type: .symbol, shape: .noShapeDark, value: symbol)
                        }
                }
            }
            .padding()
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.3), .clear]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(height: 16)
            .padding(.top, -8)
    }

    @ViewBuilder
    private var titleView: some View {
        switch icon.type {
        case .symbol:
            Label("Edit", systemImage: icon.value)
                .labelStyle(.titleAndIcon)
        case .text, .emoji:
            Label {
                Text("Edit")
            } icon: {
                IconView(icon: icon, color: color)
            }
            .labelStyle(.titleAndIcon)
        case .none:
            Text("Select new")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                symbolSelectionView
            }
            .navigationTitle("Choose icon")
            // TODO: do i need a dismiss or do i get it for free
        }
        .searchable(text: $searchText)
    }
}

//MARK: - Preview
struct IconGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView(color: .yellow, icon: .constant(Icon(type: .text, shape: .noShapeDark, value: "a")))
    }
}
