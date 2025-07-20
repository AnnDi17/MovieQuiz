//
//  MostPopularMovies.swift
//  MovieQuiz
//

import Foundation

struct ErrorMessage: Error, LocalizedError{
    let message: String
    var errorDescription: String? {
        return message
    }
    init(_ message: String) {
        self.message = message
    }
}

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
