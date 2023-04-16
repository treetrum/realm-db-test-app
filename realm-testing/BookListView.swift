//
//  BookListView.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import SwiftUI
import RealmSwift

enum PresentedSheets: Int, CaseIterable, Identifiable {
    var id: Int { self.rawValue }
    case addBook = 0
}

struct BookListView: View {
    
    @State var presentedSheet: PresentedSheets? = nil
    
    @EnvironmentObject var realmManager: RealmManager
        
    @ObservedResults(Book.self) var books
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(book.title, value: book)
                }
                .onDelete(perform: $books.remove)
            }
            .navigationTitle("All Books")
            .navigationBarItems(trailing: Button("Add book") {
                presentedSheet = .addBook
            })
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
            .sheet(item: $presentedSheet) { (sheet: PresentedSheets) in
                switch sheet {
                case .addBook:
                    AddEditBook()
                }
            }
        }
    }
}


struct BookListView_Previews: PreviewProvider {
    static let preview = RealmManager.preview

    static var previews: some View {
        BookListView()
            .environment(\.realm, preview.realm!)
            .environment(\.realmConfiguration, preview.configuration!)
            .environmentObject(preview)
    }
}
