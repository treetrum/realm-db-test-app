//
//  BookDetailView.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import SwiftUI
import RealmSwift

struct BookDetailView: View {
    
    @ObservedRealmObject var book: Book
    
    var body: some View {
        VStack {
            Text("Book").font(.headline)
            Text(book.title)
            Text("Authors").font(.headline)
            Text(book.authors)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: {
            let book = Book(title: "Test", ownerId: "")
            book.authors = "Some authors"
            return book
        }())
    }
}
