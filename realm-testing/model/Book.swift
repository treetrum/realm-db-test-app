//
//  Book.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import Foundation
import RealmSwift

class Book: Object, Identifiable {
    
    @Persisted(primaryKey: true)
    var _id: ObjectId
    var id: ObjectId { _id }
    
    @Persisted
    var title: String = ""
    
    @Persisted
    var authors: String = ""
    
    @Persisted
    var ownerId: String

    convenience init(title: String, ownerId: String) {
        self.init()
        self.title = title
        self.ownerId = ownerId
    }
}
