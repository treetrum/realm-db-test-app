//
//  SecretsStore.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import Foundation

struct ConfigStore {
    
    private static func getStringSecretFromConfig(key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }
    
    static var RealmApiKey: String {
        getStringSecretFromConfig(key: "REALM_API_KEY") ?? ""
    }
    
    static var RealmAppId: String {
        getStringSecretFromConfig(key: "REALM_APP_ID") ?? ""
    }
}
