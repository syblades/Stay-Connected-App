//
//  MessageLogView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import SwiftUI
import FirebaseFirestore

  

struct MessageLogView: View {


    var appUser: AppUser?
    var toId: String?
    
    @ObservedObject var viewModel: MessageLogViewModel
    
    
    init(appUser: AppUser?) {
        self.appUser = appUser
        self.viewModel = .init(appUser: appUser)
    }
    
    
    init(toId: String?) {
        self.toId = toId
        self.viewModel = .init(toId: toId)

    }
    
        
    
    var body: some View {
        ZStack {
            messagesView
            Text(viewModel.errorMessage)
        }
        
        .navigationTitle("\(viewModel.appUser?.username ?? "")")
            .navigationBarTitleDisplayMode(.inline)
        

    }
   
    static let emptyScroll = "Empty"
     var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(viewModel.appMessages) { message in
                            MessageView(message: message)
                        }
                        
                        HStack{ Spacer() }
                        .id(Self.emptyScroll)
                    }
                    .onReceive(viewModel.$count) { _ in
                            scrollViewProxy.scrollTo(Self.emptyScroll, anchor: .bottom)

                    }

                    
                }
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()) 
            .safeAreaInset(edge: .bottom) {
                messageBottomArea
                    .background(Color(.black).ignoresSafeArea())
            }
        }

    }
    
    
    private var messageBottomArea: some View {

        HStack(spacing: 16) {
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color(.white))
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $viewModel.messageText)
                    .opacity(viewModel.messageText.isEmpty ? 0.5: 2)
                
                
            }
            .frame(height: 50)
            
            Button {
                viewModel.handleSend()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(.systemBlue))

            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

}

struct MessageView: View {
    
    let message: AppMessage
    
    var body: some View {
        
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(Color(.white)).opacity(1.0)
                    }
                    .padding()
                    .background(Color.black.opacity(0.65))
                    
                    .cornerRadius(8)
                }
            
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(Color(.black)).opacity(1.0)
                    }
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


private struct DescriptionPlaceholder: View {
    
    var body: some View {
        HStack {
            Text("What's on Your Mind?")
                .foregroundColor(Color(.white)).opacity(1.0)
                .font(.system(size: 18, weight: .semibold))
                .padding(.leading, 5)
            Spacer()
        }.padding()
        .cornerRadius(10)
        .padding(.top, -10)
        
    }
}

