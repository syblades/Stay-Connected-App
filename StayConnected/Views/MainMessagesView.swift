//
//  MainMessagesView.swift
//  StayConnected
//
//  Created by Symone Blades on 1/30/22.
//

// private function gives access only to the class itself

import SwiftUI
import SDWebImageSwiftUI


struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    // handling click action on new message button
    @State var showCreateMessageScreen = false
    
    @State var navigateToChatLogView = false
    
    @State var showSettingsScreen = false
    
    @ObservedObject private var viewModel = MainMessagesViewModel()
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                CustomNavigationBar
                messagesView
                
                NavigationLink("", isActive: $navigateToChatLogView) {
                    MessageLogView(appUser: self.appUser)
                }

            }.overlay(
               newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
                
    }
    
    
    private var CustomNavigationBar: some View {
        
        HStack(spacing: 16) {
            
            // uses SD Web Image package to fetch user profile image from storage
            WebImage(url: URL(string: viewModel.appUser?.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            

            VStack(alignment: .leading, spacing: 4) {
                Text(" \(viewModel.appUser?.username ?? "")")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
        
            Spacer()
            

            
           
        VStack {
            NavigationLink {
                ProfileSettingsView()
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    Spacer()
                    Text("Log Out")
                        .font(.system(size: 20, weight:.bold))
                    Spacer()

                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)

            } label: {
                Text("")
                Image(systemName: "gearshape.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.label))
            }
           
        }

    }

        .padding()

        // sets the option of logging out or cancelling operation
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text(""), message: Text("Sure You Want to Log Out?"), buttons: [ .destructive(Text("Log Me Out"), action: {
                    print("handle log out")
                    viewModel.handleLogOut()
                }),
                    .cancel()
            ])
            
        }
        .fullScreenCover(isPresented: $viewModel.UserCurrentlyLoggedOut, onDismiss: nil){
            LoginView(didFinishLogin: {
                self.viewModel.UserCurrentlyLoggedOut = false
                self.viewModel.fetchCurrentUser()
            })
        }
    }
    

    private var messagesView: some View {
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessage in
                // grouped entire message view minus the header in order to apply horizontal padding
                
                VStack {
                    NavigationLink {
                        Text("Recent Messages Chat History View w/ Another User") // click on message in messageview it will take you to chat log view for user
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height:64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.username)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                                            
                            }
                            Spacer()
                            // TODO: format timezone
                            // Should display time if sent or receieved on current day
                            // else display date of last activity MM/DD/YY format
                            Text(recentMessage.timestamp.description)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }

                    
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
            
            
        }
        
    }
    
   
    private var newMessageButton: some View {
        Button {
            showCreateMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight:.bold))
                Spacer()
                
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.indigo)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $showCreateMessageScreen) {
            NewMessageView(selectedNewUser: { user in
                print(user.username)
                // new message -> user -> displays chat history with that user
                self.navigateToChatLogView.toggle()
                self.appUser = user // what user we selected
            })
        }
    }
    
    @State var appUser: AppUser? // user will be nil in the beginning
    
  
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
                MainMessagesView()
    }
}
