//
//  URLRequest+ImageGeneration.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-20.
//

import Foundation

extension URLRequest {
    static func imageGenerationRequest(for imageDescription: String) throws -> URLRequest {
        
        let url = URL(string: "https://api.openai.com/v1/images/generations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["prompt": imageDescription,
                             "n": 1,
                             "size": "1024x1024",
                             "response_format": "url"],
            options: []
        )
        return request
    }
}
