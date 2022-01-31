//
//  MainMessagesView.swift
//  StayConnected
//
//  Created by Symone Blades on 1/30/22.
//

import SwiftUI

struct MainMessagesView: View {
    
    
    @State var shouldShowLogOutOptions = false
    
    
    private var CustomNavigationBar: some View {
        
        HStack(spacing: 16) {
            
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight:.heavy))
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
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
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            

        }
        .padding()
        
        // sets the option of logging out or cancelling operation
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("Do you want to Log Out?"), buttons: [ .destructive(Text("Log Out"), action: {
                    print("handle log out")
                }),
                    .cancel()
            ])
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                // custom navigation bar
                CustomNavigationBar
                messagesView
                
            }.overlay(
               newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
            
        }
                
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
}



struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
    }
}
