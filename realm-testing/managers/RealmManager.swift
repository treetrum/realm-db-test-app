//
//  RealmManager.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import SwiftUI
import RealmSwift
import CloudKit

class RealmManager: ObservableObject {
    
    @Published var app: RealmSwift.App
    @Published var realm: Realm?
    @Published var user: User?
    @Published var configuration: Realm.Configuration?

    @AppStorage("non-sync-user-id") var nonCKUserId: String = "non-icloud-\(UIDevice.current.identifierForVendor!.uuidString)"
    @Published var ckUserId: String?
    var userId: String { ckUserId ?? nonCKUserId }
    
    init() {
        app = App(id: ConfigStore.RealmAppId)
    }
    
    @MainActor
    func bootstrap() async {
        
        // Store cloudkit user id if it exists, this allows cross device syncing
        if let ckUserId = try? await CKContainer(identifier: "iCloud.com.sjd.RealmTesting").userRecordID().recordName {
            self.ckUserId = ckUserId
            print("Got CK user: \(ckUserId)")
        }
    
        // Gets current user (will login if required)
        user = await getUser()
        guard let user = user else { fatalError("Error getting user") }
        
        // Configure subscriptions that we care about
        self.configuration = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
            if let _ = subs.first(named: "all-books") {
                // Do nothing, all-books already exists
            } else {
                subs.append(QuerySubscription<Book>(name: "all-books") {
                    return $0.ownerId == self.userId
                })
            }
        }, rerunOnOpen: true)
        guard let configuration = configuration else { fatalError("Error getting configuration") }
        
        realm = try? await Realm(configuration: configuration)
    }
    
    func getUser() async -> User? {
        if let user = app.currentUser {
            return user
        } else {
            return try? await app.login(credentials: .userAPIKey(ConfigStore.RealmApiKey))
        }
    }
}

extension RealmManager {
    static var preview: RealmManager {
        let manager = RealmManager()
        let config = Realm.Configuration(inMemoryIdentifier: "in-memory")
        manager.configuration = config
        let realm = try! Realm(configuration: config)
        manager.realm = realm

        try! realm.write {
            realm.add(Book(title: "First book", ownerId: ""))
            realm.add(Book(title: "Second book", ownerId: ""))
            realm.add(Book(title: "Third book", ownerId: ""))
        }
        
        return manager
    }
}
