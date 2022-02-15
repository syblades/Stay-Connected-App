//
//  SearchBarView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/14/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String

    @State private var isEditing = false
    
    var body: some View {
        HStack {
                    
                TextField("Search ...", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.searchText = ""
                                    
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
//                if isEditing {
//                    Button(action: {
//                        self.isEditing = false
//                        self.searchText = ""
//
//                        // Dismiss the keyboard
////                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    }) {
//                        Text("Cancel")
//                    }
//                    .padding(.trailing, 10)
//                    .transition(.move(edge: .trailing))
//
//                }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
