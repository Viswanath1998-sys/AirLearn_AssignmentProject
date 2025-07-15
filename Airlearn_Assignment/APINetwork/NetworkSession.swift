//
//  NetworkSession.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import Foundation



final class NetworkSession{
    static let shared = NetworkSession()
//    let githubToken = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] ?? ""

      private init() {}
    
//    func fetch<T: Decodable>(url: String, response: T.Type) async -> Result<T, APIError> {
//        guard let url = URL(string: url) else {
//            return  .failure(.invalidURL)
//        }
//        var request = URLRequest(url: url)
//          request.httpMethod = "GET"
//
//          //Required by GitHub
//          request.setValue("AirLearn_AssignmentProject", forHTTPHeaderField: "User-Agent")
//              request.setValue("token \(githubToken)", forHTTPHeaderField: "Authorization")
//        do{
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse else{
//                return .failure(.invalidResponse)
//            }
//
//            if httpResponse.statusCode == 404{
//                return .failure(.userNotFound)
//            }
//            guard 200..<300 ~= httpResponse.statusCode else {
//                return .failure(.invalidResponse)
//            }
////            }
//
//            do{
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                return .success(decodedData)
//            }catch{
//                return .failure(.decodingError(error))
//            }
//
//        }catch{
//
//            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet{
//                return .failure(.noInternetConnection)
//            }else{
//                NetworkMonitoringService.shared.recheck()
//                return .failure(.networkError(error))
//            }
//        }
//    }
    
    
    func fetch<T: Decodable>(url: String, response: T.Type) async -> Result<T, APIError> {
        guard let url = URL(string: url) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if httpResponse.statusCode == 404 {
                return .failure(.userNotFound)
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                return .failure(.invalidResponse)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingError(error))
            }
            
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                return .failure(.noInternetConnection)
            } else {
                NetworkMonitoringService.shared.recheck()
                return .failure(.networkError(error))
            }
        }
    }
}




enum APIError: Error, LocalizedError {
    case invalidURL
    case userNotFound
    case noInternetConnection
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .userNotFound:
            return "User not found."
        case .noInternetConnection:
            return "No internet connection. Please check your network and try again."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
