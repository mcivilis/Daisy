//
//  PetalShape.swift
//  Daisy
//
//  Created by Maria Civilis on 2022-12-15.
//

import SwiftUI

struct PetalParameters {
    struct Segment {
        let line: CGPoint
        let control: CGPoint
    }

    static let adjustment: CGFloat = 0.085
    static let segments = [
        Segment(
            line:     CGPoint(x: 0.55, y: 0.10),
            control: CGPoint(x: 0.53, y: 0.00)
        ),
        Segment(
            line:     CGPoint(x: 0.62, y: 0.60),
            control: CGPoint(x: 0.64, y: 0.40)
        ),
        Segment(
            line:     CGPoint(x: 0.50, y: 1.00),
            control: CGPoint(x: 0.60, y: 1.00)
        ),
        Segment(
            line:     CGPoint(x: 0.38, y: 0.60),
            control: CGPoint(x: 0.38, y: 1.00)
        ),
        Segment(
            line:     CGPoint(x: 0.40, y: 0.30),
            control: CGPoint(x: 0.38, y: 0.40)
        ),
        Segment(
            line:     CGPoint(x: 0.50, y: 0.00),
            control: CGPoint(x: 0.45, y: 0.00)
        )
    ]
}

struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = min(rect.size.width, rect.size.height)
            let height = width
            
            path.move(
                to: CGPoint(
                    x: width * 0.50,
                    y: height * 0.00
                )
            )
            
            PetalParameters.segments.forEach { segment in
                path.addQuadCurve(
                    to: CGPoint(
                        x: width * segment.line.x,
                        y: height * segment.line.y
                    ),
                    control: CGPoint(
                        x: width * segment.control.x,
                        y: height * segment.control.y
                    )
                )
            }
        }
    }
}

struct PetalView: View {
    var body: some View {
        GeometryReader { geometry in
            PetalShape()
            .stroke(.black, lineWidth: 8)
            .background(PetalShape().fill(.white))
            .shadow(color: Color.gray, radius: 10, x: 5, y: 5)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PetalShape_Previews: PreviewProvider {
    static var previews: some View {
        PetalView()
    }
}
