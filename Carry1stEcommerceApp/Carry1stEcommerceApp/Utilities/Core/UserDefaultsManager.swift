//
//  UserDefaultsManager.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 25/11/2024.
//

import Foundation


class UserDefaultsManager {
    private let userDefaults: UserDefaults
        
        init(userDefaults: UserDefaults = .standard) {
            self.userDefaults = userDefaults
        }
    
    /// Save a Codable object to UserDefaults
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
            print("Object saved to UserDefaults with key: \(key)")
        } catch {
            print("Failed to encode and save object: \(error)")
        }
    }
    
    /// Fetch a Codable object from UserDefaults
    func fetch<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            print("No object found in UserDefaults for key: \(key)")
            return nil
        }
        
        do {
            let object = try JSONDecoder().decode(type, from: data)
            print("Object fetched from UserDefaults with key: \(key)")
            return object
        } catch {
            print("Failed to decode object: \(error)")
            return nil
        }
    }
    
    /// Remove an object from UserDefaults
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        print("Object removed from UserDefaults with key: \(key)")
    }
}
