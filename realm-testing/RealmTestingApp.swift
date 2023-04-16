//
//  RealmTestingApp:.swift
//  RealmTestingApp
//
//  Created by Samuel Davis on 16/4/2023.
//

import SwiftUI
import RealmSwift

@main
struct RealmTestingApp: SwiftUI.App {
    
    @ObservedObject var realmManager = RealmManager()
    
    var body: some Scene {
        WindowGroup {
            if let realm = realmManager.realm {
                BookListView()
                    .environment(\.realm, realm)
                    .environmentObject(realmManager)
            } else {
                ProgressView()
                    .task {
                        await realmManager.bootstrap()
                    }
            }
        }
    }
}
