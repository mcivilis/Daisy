//
//  Image+Data.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-13.
//

import UIKit
import SwiftUI

extension Image {
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
}
