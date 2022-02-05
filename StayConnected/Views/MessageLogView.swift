//
//  MessageLogView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import SwiftUI
import FirebaseFirestore

  

struct MessageLogView: View {


    let appUser: AppUser?
    
    init(appUser: AppUser?) {
        self.appUser = appUser
        self.viewModel = .init(appUser: appUser)
    }
        
    @ObservedObject var viewModel: MessageLogViewModel
    
    var body: some View {
        ZStack {
            messagesView
            Text(viewModel.errorMessage)
        }
        
        .navigationTitle(appUser?.username ?? "") // displays the users username at the top of the chat window
            .navigationBarTitleDisplayMode(.inline)
    }
   
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ForEach(0..<20) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("Sample Message")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                }
                
                HStack{ Spacer() }
                
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                messageBottomArea
                    .background(Color(.systemBackground).ignoresSafeArea())
            }
        }

    }
    
    
    private var messageBottomArea: some View {

        HStack(spacing: 16) {
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.messageText) // have to use viewmodel since messageText is a published variable
                    .opacity(viewModel.messageText.isEmpty ? 0.5: 1)
            }
            .frame(height: 60)
            
            Button {
                viewModel.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

}


private struct DescriptionPlaceholder: View {
    
    var body: some View {
        HStack {
            Text("What's on Your Mind?")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct MessageLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MessageLogView(appUser: .init(data: ["username" : "syblades"]))
        }

    }
}