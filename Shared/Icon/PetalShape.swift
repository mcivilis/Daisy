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
            line:     CGPoint(x: 0.55, y: 0.30),
            control: CGPoint(x: 0.53, y: 0.20)
        ),
        Segment(
            line:     CGPoint(x: 0.60, y: 0.70),
            control: CGPoint(x: 0.60, y: 0.70)
        ),
        Segment(
            line:     CGPoint(x: 0.50, y: 0.90),
            control: CGPoint(x: 0.60, y: 0.90)
        ),
        Segment(
            line:     CGPoint(x: 0.40, y: 0.70),
            control: CGPoint(x: 0.40, y: 0.90)
        ),
        Segment(
            line:     CGPoint(x: 0.45, y: 0.30),
            control: CGPoint(x: 0.45, y: 0.30)
        ),
        Segment(
            line:     CGPoint(x: 0.50, y: 0.20),
            control: CGPoint(x: 0.47, y: 0.20)
        )
    ]
}

struct PetalShapeView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width

                path.move(
                    to: CGPoint(
                        x: width * 0.50,
                        y: height * 0.20
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
            .stroke(.black, lineWidth: 2)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

struct PetalShapeView_Previews: PreviewProvider {
    static var previews: some View {
        PetalShapeView()
    }
}
