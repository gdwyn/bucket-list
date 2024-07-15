//
//  EditView.swift
//  BucketList
//
//  Created by Godwin IE on 18/06/2024.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name = ""
    @State private var description = ""
    var onSave: (Location) -> Void
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby places") {
                    
                    switch loadingState {
                    case .loading:
                        Text("LOADING...")
                        
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": ") +
                            
                            Text("Page description here")
                                .italic()
                        }
                        
                    case .failed:
                        Text("Please try again later...")
                    } //switch
                    
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.name = name
                    newLocation.id = UUID()
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
        } //nav stack
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
