//
//  DaisyIcon.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-15.
//

import SwiftUI

struct PetalGroup: View {
    let size: CGSize
    
    var body: some View {
        ZStack {
            PetalView()
                .rotationEffect(.degrees(180), anchor: .center)
                .scaleEffect(1.0 / 2.5, anchor: .center)
                .position(x: size.width / 2, y: size.height / 5)
        }
    }
}

struct DaisyIcon: View {
    
    struct Petal: Identifiable {
        var id = UUID()
        var isVisible: Bool
        var angle: Double
        
        @ViewBuilder
        func view(size: CGSize) -> some View {
            PetalView()
                .rotationEffect(.degrees(180), anchor: .center)
                .scaleEffect(1.0 / 2.5, anchor: .center)
                .position(x: size.width / 2, y: size.height / 5)
        }
    }
    
    let petals: [Petal] = {
        (0...24).map {
            Petal(isVisible: true, angle: (Double($0) / Double(24)) * 360.0)
        }
    }()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach(petals) { petal in
                    petal.view(size: geometry.size)
                        .opacity(petal.isVisible ? 1.0 : 0.0)
                        .rotationEffect(.degrees(petal.angle), anchor: .center)
                }
                Circle()
                    .stroke(.black.opacity(0.8), lineWidth: 12)
                    .background(Circle().fill(Color.accentColor))
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                    .scaleEffect(1.0 / 4, anchor: .center)
            }
        }
        .padding()
        .scaledToFit()
    }
}

struct DaisyIcon_Previews: PreviewProvider {
    static var previews: some View {
        DaisyIcon()
    }
}
