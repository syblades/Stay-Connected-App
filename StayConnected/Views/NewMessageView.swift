//
//  NewMessageView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/2/22.
//

import SwiftUI
import SDWebImageSwiftUI


// creating observable object to fetch data from db
class NewMessageViewModel: ObservableObject {
    
    @Published var users = [AppUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }

    
    // populating empty array with all users in db
    // look for person in db from their username
    // add that user to contacts
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({snapshot in
                    let data = snapshot.data()
                    self.users.append(.init(data: data))
                })
            }
    }
}
struct NewMessageView: View {
    
    let selectedNewUser: (AppUser) -> ()
    
    @State private var searchText = ""
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = NewMessageViewModel()
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                    .padding()
                  
                ScrollView {
                    ForEach(self.viewModel.users.filter(
                        { searchText.isEmpty ? true : $0.username.localizedCaseInsensitiveContains(searchText) }
                    )) { user in
                        Button {
                                presentationMode.wrappedValue.dismiss()
                                selectedNewUser(user)
        
                            } label: {
                                HStack(spacing: 16) {
                                    WebImage(url: URL(string:user.profileImageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 54, height:54)
                                        .clipped()
                                        .cornerRadius(54)
                                        .overlay(RoundedRectangle(cornerRadius: 54).stroke(Color.black, lineWidth: 1))
                                        .shadow(radius: 5)
                                    Text(user.username)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(.white))
                                    Spacer()
                                }.padding(.horizontal)
                                    .padding(.vertical, 4)
        
                            }
                            
                    }
                }
         
            }.navigationTitle("New Message 💬")
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea())
            .toolbar {
                ToolbarItemGroup(placement:
                    .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label : {
                        Text("Cancel")
                    }
                }

            }
        }
    }
    
        
}
