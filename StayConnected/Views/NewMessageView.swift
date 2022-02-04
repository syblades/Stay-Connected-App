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
    
    // using empty array
    @Published var users = [AppUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }

    
    // populating empty array with all users in db
    // look for person in db from their username
    // add that user to contacts
    // each user will need contact list
    // individual chat and group chat functionality (can name group chat)
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
    
    // creating a callback
    let selectedNewUser: (AppUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = NewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                Text(viewModel.errorMessage)
                Text("SEARCH BAR WILL GO HERE")
                // on this line implement search bar functionality
                ForEach(viewModel.users) { user in
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        selectedNewUser(user)

                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string:user.profileImageURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped() // clips off edges outside of frame
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
                            Text(user.username)
                                .foregroundColor(Color(.label))
                            Spacer()

                        }.padding(.horizontal)
                        
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }.navigationTitle("New Message")
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
 
struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
