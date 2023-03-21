//
//  ImageGenerationClient.swift
//  Daisy (iOS)
//
//  Created by Maria Civilis on 2023-03-14.
//

import Foundation
import Combine
import ComposableArchitecture
import UIKit

public struct ImageGenerationClient {
    
    var imageData: @Sendable (String) async throws -> Data
}

extension DependencyValues {
    var imageGenerationClient: ImageGenerationClient {
        get { self[ImageGenerationClient.self] }
        set { self[ImageGenerationClient.self] = newValue }
    }
}

extension ImageGenerationClient: DependencyKey {
    public static let liveValue = ImageGenerationClient { description in
        try await generateImageData(with: description)
    }
}

// MARK: - Fetch

extension ImageGenerationClient {
    
    enum ImageGenerationClientError: Error {
        case badRequest
        case failedToGenerateImage
        case other(Error)
    }
    
    struct ImageDataResponse: Codable {
        let created: Int
        let data: [ImageData]
    }

    struct ImageData: Codable {
        let url: String
    }
    
    private static func generateImageData(with description: String) async throws -> Data {
        let request = try URLRequest.imageGenerationRequest(for: description)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
            throw ImageGenerationClientError.badRequest
        }
        
        let decoder = JSONDecoder()
        let imageDataResponse = try decoder.decode(ImageDataResponse.self, from: data)
        
        guard
            let url = imageDataResponse.data.first?.url,
            let imageURL = URL(string: url) else {
            throw ImageGenerationClientError.failedToGenerateImage
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        
        return imageData
        
    }
    
    private static func generateImageData(with description: String) -> AnyPublisher<Data, Error> {
        do {
            // 1. Request `ImageDataResponse` that returns an array of `ImageData` containing image URLs
            let request = try URLRequest.imageGenerationRequest(for: description)
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                // 2. Flat map response to image data
                .flatMap { (data, response) -> AnyPublisher<Data, Error> in
                    guard
                        let httpResponse = response as? HTTPURLResponse,
                        (200..<300).contains(httpResponse.statusCode) else {
                        return Fail(error: ImageGenerationClientError.badRequest).eraseToAnyPublisher()
                    }
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(ImageDataResponse.self, from: data)
                        // 3. Does response have a valid image URL?
                        guard
                            let url = response.data.first?.url,
                            let imageURL = URL(string: url) else {
                            return Fail(error: ImageGenerationClientError.failedToGenerateImage).eraseToAnyPublisher()
                        }
                        // 4. Fetch data contents of the image URL
                        return URLSession.shared.dataTaskPublisher(for: imageURL)
                            .map { $0.data }
                            .mapError { ImageGenerationClientError.other($0) }
                            .eraseToAnyPublisher()
                    } catch {
                        return Fail(error: ImageGenerationClientError.other(error)).eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
