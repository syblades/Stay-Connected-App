//
//  SearchBarView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/13/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var value: String
    @State var isSearching = false
    
    
    var body: some View {
        HStack {
            TextField("Search Users", text: $value)
                .padding(.leading, 24)
        }.padding()
            .background(Color(.systemGray5))
            .cornerRadius(6.0)
            .padding(.horizontal)
            .onTapGesture(perform: {
                isSearching = true
            })
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    
                    Button ( action: {value = ""} ) {
                        Image(systemName: "xmark.circle.fill")
                    }

                }.padding(.horizontal, 32)
                .foregroundColor(.gray)
            
            )
    }
}
//
//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView()
//    }
//}
