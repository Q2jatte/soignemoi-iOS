//
//  API.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 05/12/2023.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case serializationError
    case missingToken
    case authenticationFailure
    case serverConnectionError
    case cannotConnectToHost
    case domain
    case unhandledResponse(Int)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .serializationError:
            return "Erreur de sérialisation"
        case .missingToken:
            return "Token manquant"
        case .authenticationFailure:
            return "Échec de l'authentification. Identifiants incorrects."
        case .serverConnectionError:
            return "Impossible de se connecter au serveur."
        case .cannotConnectToHost:
            return "Impossible de se connecter au serveur."
        case .domain:
            return "Impossible de joindre le serveur."
        case .unhandledResponse(let statusCode):
            return "Réponse non gérée. Code de réponse : \(statusCode)"
        }
    }
    
    // Additional initializer to map from generic Error
    init(_ error: Error) {
        if let apiError = error as? ApiError {
            self = apiError
        } else {
            self = .unhandledResponse((error as NSError).code)
        }
    }
}

class Api {
    
    let rootURL = URL(string: "http://127.0.0.1:8000")
    static let loginURL = URL(string: "http://127.0.0.1:8000/api/login_check")
    
    static func sendLoginRequest(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        guard let url = self.loginURL else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        // Préparation des données
        let userData = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            completion(.failure(ApiError.serializationError))
            return
        }
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Création de la tâche URLSession pour envoyer la requête
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Code http de réponse : \(httpResponse.statusCode)")
                
                // Gérer les différentes réponses HTTP
                switch httpResponse.statusCode {
                case 200:
                    if let responseData = data {
                        do {
                            // Désérialisation du JSON
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                // Extraction de la valeur pour la clé "token"
                                if let token = json["token"] as? String {
                                    completion(.success(token))
                                } else {
                                    completion(.failure(ApiError.missingToken))
                                }
                            }
                        } catch {
                            print("Erreur lors de la désérialisation JSON : \(error)")
                            completion(.failure(error))
                        }
                    }
                    
                case 401:
                    completion(.failure(ApiError.authenticationFailure))
                    
                default:
                    completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                }
            }
        }
        task.resume()
        
    }
}


