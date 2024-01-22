//
//  TokenManager.swift
//  SoigneMoi
//
//  Created by Eric Terrisson on 22/01/2024.
//

import Foundation

/**
 Erreurs spécifiques à la gestion du token.
 */
enum TokenManagerError: Error {
    case expirationNotAvailable
}

/**
 Gestionnaire du token pour l'authentification.
 */
class TokenManager {
    
    /// Token d'authentification.
    var token: String = ""
    
    /// Date d'expiration du token.
    var expirationToken: Date?
    
    /// Méthode pour définir le token.
    func setToken(token: String) {
        self.token = token
        updateExpirationToken()
    }
    
    /**
     Méthode pour retourner le token de manière synchrone.
     
     - Returns: Le token d'authentification.
     */
    func getToken() -> String {
        guard let expiration = self.expirationToken else {
            return ""
        }

        if Date() > expiration {
            return fetchNewTokenSync()
        } else {
            return self.token
        }
    }
    
    /**
     Méthode pour effectuer une demande de connexion et obtenir un nouveau token de manière synchrone.
     
     - Returns: Le nouveau token d'authentification.
     */
    private func fetchNewTokenSync() -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var resultToken: String = ""

        fetchNewToken { result in
            switch result {
            case .success(let receivedToken):
                resultToken = receivedToken
            case .failure(let error):
                print(error)
            }
            semaphore.signal()
        }

        semaphore.wait()
        return resultToken
    }
    
    /**
     Méthode pour effectuer une demande de connexion et obtenir un nouveau token.
     
     - Parameter completion: Une closure appelée une fois que la requête est terminée.
     */
    private func fetchNewToken(completion: @escaping (Result<String, Error>) -> Void) {
        let api = Api()
        api.sendLoginRequest(username: ActiveUser.shared.username, password: ActiveUser.shared.password) { result in
            completion(result)
        }
    }
    
    /// Méthode pour mettre à jour la date d'expiration à partir du payload du token.
    private func updateExpirationToken() {
        let tokenParts = token.components(separatedBy: ".")
        
        guard tokenParts.count >= 2 else {
            // Gérer le cas où le token n'a pas le format attendu
            self.expirationToken = nil
            return
        }

        let payloadData = tokenParts[1].base64DecodedData()
        let jsonDecoder = JSONDecoder()

        do {
            let payload = try jsonDecoder.decode(JWTPayload.self, from: payloadData)
            self.expirationToken = Date(timeIntervalSince1970: TimeInterval(payload.exp))
        } catch {
            // Gérer les erreurs de décodage du payload
            self.expirationToken = nil
        }
    }
}

// Extension pour décoder les données base64.
extension String {
    func base64DecodedData() -> Data {
        let padded = self.padding(toLength: ((self.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        guard let decodedData = Data(base64Encoded: padded) else {
            fatalError("Error decoding base64.")
        }
        return decodedData
    }
}
