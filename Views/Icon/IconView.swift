//
//  IconView.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-09-21.
//

import SwiftUI

@MainActor
struct IconView: View {
    
    let icon: Icon
    let color: Color
    
    private var uiImage: UIImage? {
        let view = Text(icon.value).font(.system(size: 600))
        switch icon.shape {
        case .circleDark, .rectangleDark, .noShapeDark:
            let renderer = ImageRenderer(content: view.foregroundColor(Color(UIColor.label)))
            return  renderer.uiImage
        case .circleLight, .rectangleLight:
            let renderer = ImageRenderer(content: view.foregroundColor(Color(UIColor.systemBackground)))
            return  renderer.uiImage
        case .noShapeLight:
            let renderer = ImageRenderer(content: view.foregroundColor(color))
            return  renderer.uiImage
        }
    }
    
    var body: some View {
        switch icon.type {
        case .symbol:
            Image(systemName: icon.value)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
        case .text, .emoji:
            if let uiImage {
                switch icon.shape {
                case .noShapeDark, .noShapeLight:
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .circleDark, .circleLight:
                    Circle()
                        .fill(color)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        )
                        .clipShape(Circle())
                case .rectangleDark, .rectangleLight:
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            } else {
                EmptyView()
            }
        case .none:
            EmptyView()
        }
    }
}

struct IconRenderView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ForEach(IconShape.allCases, id: \.self) {
                    IconView(icon: Icon(type: .text, shape: $0, value: "P"), color: .pink)
                }
            }
            Spacer()
            VStack {
                ForEach(IconShape.allCases, id: \.self) {
                    IconView(icon: Icon(type: .emoji, shape: $0, value: "🐷"), color: .pink)
                }
            }
        }
        .padding()
    }
}

