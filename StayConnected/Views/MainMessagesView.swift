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
    @ObservedObject private var viewModel = MainMessagesViewModel()
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                CustomNavigationBar
                messagesView

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
            
            // TODO: need to incorporate Profile settings view in this button action
            Menu {
                Button(action:{}, label: {
                    Text("Settings")
                })
                    // edit profile, enable dark mode, delete profile
                
                
                Button(action:{shouldShowLogOutOptions.toggle()}, label: {
                    Text("Logout")
                })
            } label: {
                Label(
                    title: {Text("")},
                    icon: { Image(systemName: "gearshape.fill")}
                    
                )
            }.font(.system(size: 24, weight: .bold))
            .foregroundColor(Color(.label))

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
    //CREATE full screen cover here for settings page
}
        


    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                // grouped entire message view minus the header in order to apply horizontal padding
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1) // support dark and light mode
                            )
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 14, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                                        
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
            
            
        }
        
    }
    
    
    private var newMessageButton: some View {
        Button {
        
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
    }



struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
