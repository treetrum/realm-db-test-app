//
//  AddEditBook.swift
//  realm-testing
//
//  Created by Samuel Davis on 16/4/2023.
//

import SwiftUI

struct AddEditBook: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State var title = ""
    @State var authors = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Authors", text: $authors)
                }
                Section {
                    Button("Save", action: onSave)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Add book")
        }
    }
    
    func onSave() {
        let book = Book(title: title, ownerId: realmManager.userId)
        book.authors = authors
        try? realmManager.realm?.write({
            realmManager.realm!.add(book)
        })
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddEditBook_Previews: PreviewProvider {
    static var previews: some View {
        AddEditBook()
            .environmentObject(RealmManager.preview)
    }
}
