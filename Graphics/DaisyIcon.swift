//
//  DaisyIcon.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-15.
//

import SwiftUI

struct DaisyIcon: View {
    private let usesShadow: Bool
    private let strokeWidth: CGFloat
    private let petals: [Petal]
    
    struct Petal: Identifiable {
        var id = UUID()
        var angle: Double
        let usesShadow: Bool
        let strokeWidth: CGFloat
        
        @ViewBuilder
        func view(size: CGSize) -> some View {
            PetalView(usesShadow: usesShadow, strokeWidth: strokeWidth)
                .rotationEffect(.degrees(180), anchor: .center)
                .scaleEffect(1.0 / 2.5, anchor: .center)
                .position(x: size.width / 2, y: size.height / 5)
                .foregroundColor(.white)
        }
    }
    
    public init(
        petals: Int = 24,
        usesShadow: Bool = true,
        strokeWidth: CGFloat = 10
    ) {
        self.petals = {
            (0...petals).map {
                Petal(
                    angle: (Double($0) / Double(petals)) * 360.0,
                    usesShadow: usesShadow,
                    strokeWidth: strokeWidth
                )
            }
        }()
        self.usesShadow = usesShadow
        self.strokeWidth = strokeWidth
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ForEach(petals) { petal in
                    petal.view(size: geometry.size)
                        .rotationEffect(.degrees(petal.angle), anchor: .center)
                }
                Circle()
                    .stroke(.black.opacity(0.8), lineWidth: strokeWidth*1.2)
                    .background(Circle().fill(.yellow))
                    .if(usesShadow, transform: { view in
                        view.shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)
                    })
                    
                    .scaleEffect(1.0 / 4, anchor: .center)
            }
        }
        .padding()
        .scaledToFit()
    }
}

struct DaisyIcon_Previews: PreviewProvider {
    static var previews: some View {
        DaisyIcon(
            petals: 16,
            usesShadow: false,
            strokeWidth: 4
        )
    }
}
