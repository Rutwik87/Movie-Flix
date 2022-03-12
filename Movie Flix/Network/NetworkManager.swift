//
//  NetworkManager.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 10/03/22.
//

import Foundation


enum APIEndPoint: String {
case nowPlaying = "now_playing"
}

enum NetworkError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "059551bc6d4c2bbe70d2e1fc16292ace"
    private let baseURL = "https://api.themoviedb.org/3"
    private let posterBaseURL = "https://image.tmdb.org/t/p/w300"
    let backdropBaseURL = "https://image.tmdb.org/t/p/original"
    
    private var imageCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func fetchMovies(completion: @escaping (Result<MovieDataResponse,Error>) -> ()) {
        var urlComponents = URLComponents(string: "\(baseURL)/movie/\(APIEndPoint.nowPlaying.rawValue)")
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badResponse(response)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MovieDataResponse.self, from: data)
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func download(imageURL: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        if let imageData = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(.success(imageData as Data))
          return
        }
        
        URLSession.shared.downloadTask(with: imageURL) { localUrl, response, error in
          if let error = error {
              completion(.failure(error))
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
              completion(.failure(NetworkError.badResponse(response)))
            return
          }
          
          guard let localUrl = localUrl else {
              completion(.failure(NetworkError.badLocalUrl))
            return
          }
          
          do {
            let data = try Data(contentsOf: localUrl)
            self.imageCache.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
              completion(.success(data))
          } catch let error {
              completion(.failure(error))
          }
        }.resume()
      }
    
    func posterImage(movie: Movie, completion: @escaping (Result<Data, Error>) -> ()) {
        let url = URL(string: "\(posterBaseURL)\(movie.posterPath)")!
        download(imageURL: url, completion: completion)
    }
    
    func backdropImage(movie: Movie, completion: @escaping (Result<Data, Error>) -> ()) {
        let url = URL(string: "\(backdropBaseURL)\(movie.backdropPath)")!
        download(imageURL: url, completion: completion)
    }
}
