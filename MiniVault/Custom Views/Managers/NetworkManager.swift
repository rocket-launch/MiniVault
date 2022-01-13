//
//  NetworkManager.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

final class NetworkManager {
    
    enum MVError: Swift.Error {
        case invalidURL
        case invalidData
        case invalidResponse
    }
    
    private let cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    private let baseURL = "https://lit-earth-91645.herokuapp.com/images/"
    
    private init() { }
    
    func fetchImageURLs(for page: Int) async throws -> [String] {
        guard let url = URL(string: "\(baseURL)\(page)") else {
            throw MVError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw MVError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        guard let imageURLs = try? decoder.decode([String].self, from: data) else {
            throw MVError.invalidData
        }
        
        return imageURLs
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw MVError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw MVError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else { return nil }
        
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
