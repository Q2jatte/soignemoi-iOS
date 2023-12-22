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
    case invalidData
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
        case .invalidData:
            return "Données invalides."
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
    
    static let baseURL = URL(string: "http://127.0.0.1:8000")!
    static let loginURL = baseURL.appendingPathComponent("/api/login_check")
    static let getPatientURL = baseURL.appendingPathComponent("/api/patients")
    static let searchPatientURL = baseURL.appendingPathComponent("/api/patients/search")
    static let getPrescriptionsURL = baseURL.appendingPathComponent("/api/prescriptions")
    static let getCommentsURL = baseURL.appendingPathComponent("/api/comments")
    static let getStaysByPatientAndStatusURL = baseURL.appendingPathComponent("/api/patients")
    static let createNewPrescriptionURL = baseURL.appendingPathComponent("/api/prescription/new")
    static let createNewCommentURL = baseURL.appendingPathComponent("/api/comment/new")
    
    
    // LOGIN
    static func sendLoginRequest(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        let url = self.loginURL
        
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
    
    // GET PATIENT - Retourne les patients du jour
    static func getPatientRequest(completion: @escaping (Result<[VisitData], Error>) -> Void) {
        
        let url = self.getPatientURL
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
        
        
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
                            // Désérialisation du JSONen [Patient]
                            //let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Patient]
                            //completion(.success(json!))
                            
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let patients = try jsonDecoder.decode([VisitData].self, from: responseData)
                            completion(.success(patients))
                            
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
    
    // SEARCH PATIENT - Retourne les patients en fonction des caractères passés
    static func searchPatientRequest(partial: String, completion: @escaping (Result<[Patient], Error>) -> Void) {
        
        let url = self.searchPatientURL
        
        // Préparation des données
        let queryData = ["query": partial]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: queryData, options: []) else {
            completion(.failure(ApiError.serializationError))
            return
        }
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
        
        
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
                            // Désérialisation du JSONen [Patient]
                            let jsonDecoder = JSONDecoder()
                            let patients = try jsonDecoder.decode([Patient].self, from: responseData)
                            completion(.success(patients))
                            
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
    
    // GET STAYS - Retourne les séjours : en cours, à venir, ancient et tous en fonction de l'id patient
    static func getStaysByPatientAndStatus(id: Int, status: String, completion: @escaping (Result<[Stay], Error>) -> Void) {
        
        // Fabrication de l'URL avec id et status
        guard let url = URL(string: self.getStaysByPatientAndStatusURL.absoluteString + "/\(id)" + "/stays" + "/\(status)") else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
        
        
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
                            // Désérialisation du JSON en [Prescription] en intégrant le bon format de date
                                                        
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let stays = try jsonDecoder.decode([Stay].self, from: responseData)
                            completion(.success(stays))
                            
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
    
    
    // GET PRESCRIPTIONS - Retourne toutes les prescriptions d'un patient
    static func getPrescriptionsForOnePatient(id: Int, completion: @escaping (Result<[Prescription], Error>) -> Void) {
        
        // Fabrication de l'URL avec id
        guard let url = URL(string: self.getPrescriptionsURL.absoluteString + "/\(id)") else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
        
        
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
                            // Désérialisation du JSON en [Prescription] en intégrant le bon format de date
                                                        
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let prescriptions = try jsonDecoder.decode([Prescription].self, from: responseData)
                            completion(.success(prescriptions))
                            
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
    
    // GET COMMENTS - Retourne tout les commentaires d'un patient
    static func getcommentsForOnePatient(id: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        // Fabrication de l'URL avec id
        guard let url = URL(string: self.getCommentsURL.absoluteString + "/\(id)") else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
        
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
                            // Désérialisation du JSON en [Comment] en intégrant le bon format de date
                                                        
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let comments = try jsonDecoder.decode([Comment].self, from: responseData)
                            completion(.success(comments))
                            
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
    
    // POST NEW PRESCRIPTION
    static func createNewPrescription(prescription: Prescription, completion: @escaping (Result<String, Error>) -> Void) {
        
        let url = self.createNewPrescriptionURL
        
        // Préparation des données
        let jsonEncoder = JSONEncoder()
        // encoder ne connait pas le format retourné par Date...
        jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        do {
            let jsonData = try jsonEncoder.encode(prescription)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
            
            // Création de la requête
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
            
            // Création de la tâche URLSession pour envoyer la requête
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Code http de réponse : \(httpResponse.statusCode)")
                    
                    // Gérer les différentes réponses HTTP
                    switch httpResponse.statusCode {
                    case 201:
                        if let responseData = data {
                            // Convertir les données en chaîne de caractères
                            do {
                                let response = try JSONDecoder().decode(ResponseMessage.self, from: responseData)
                                completion(.success(response.message))
                                
                            } catch {
                                print("Erreur lors de la désérialisation JSON : \(error)")
                                completion(.failure(error))
                            }
                        }
                    default:
                        completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                    }
                }
            }
            task.resume()
        } catch {
            completion(.failure(ApiError.serializationError))
            return
        }
    }
    
    // POST NEW COMMENT
    static func createNewComment(comment: Comment, completion: @escaping (Result<String, Error>) -> Void) {
        
        let url = self.createNewCommentURL
        
        // Préparation des données
        let jsonEncoder = JSONEncoder()
        // encoder ne connait pas le format retourné par Date...
        jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        do {
            let jsonData = try jsonEncoder.encode(comment)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
            
            // Création de la requête
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("bearer \(ActiveUser.shared.token)", forHTTPHeaderField: "Authorization")
            
            // Création de la tâche URLSession pour envoyer la requête
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Code http de réponse : \(httpResponse.statusCode)")
                    
                    // Gérer les différentes réponses HTTP
                    switch httpResponse.statusCode {
                    case 201:
                        if let responseData = data {
                            // Convertir les données en chaîne de caractères
                            do {
                                let response = try JSONDecoder().decode(ResponseMessage.self, from: responseData)
                                completion(.success(response.message))
                            } catch {
                                print("Erreur lors de la désérialisation JSON : \(error)")
                                completion(.failure(error))
                            }
                        }
                    default:
                        completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                    }
                }
            }
            task.resume()
        } catch {
            completion(.failure(ApiError.serializationError))
            return
        }
    }
}


