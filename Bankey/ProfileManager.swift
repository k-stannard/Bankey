//
//  ProfileManager.swift
//  Bankey
//
//  Created by Koty Stannard on 1/12/22.
//

import Foundation

protocol ProfileManageable: AnyObject {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case serverError
    case decodingError
    
    var title: String {
        switch self {
        case .serverError:
            return "Server Error"
        case .decodingError:
            return "Decoding Error"
        }
    }
    
    var message: String {
        switch self {
        case .serverError:
            return "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            return "We could not process your request. Please try again."
        }
    }
}

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class ProfileManager: ProfileManageable {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) ->Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }

                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    completion(.success(profile))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
