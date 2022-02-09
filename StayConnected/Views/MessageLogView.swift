//
//  MessageLogView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/4/22.
//

import SwiftUI
import FirebaseFirestore

  

struct MessageLogView: View {

    @ObservedObject var viewModel: MessageLogViewModel
    static let emptyScroll = "Empty"


    let appUser: AppUser?
    
    init(appUser: AppUser?) {
        self.appUser = appUser
        self.viewModel = .init(appUser: appUser)
    }
        
    
    
    var body: some View {
        ZStack {
            messagesView
            Text(viewModel.errorMessage)
        }
        
        .navigationTitle(appUser?.username ?? "") // displays the users username at the top of the chat window
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(trailing: Button(action: {
//                viewModel.count += 1
//            }, label: {
//                Text("Count: \(viewModel.count)")
//            }))
    }
   
    private var messagesView: some View {
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
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScroll, anchor: .bottom)
                        }
                    }

                    
                }
                
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
                .foregroundColor(Color(.label))
            
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

struct MessageView: View {
    
    let message: AppMessage
    
    var body: some View {
        
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid { // checking to see if this user if the sender to set the ui for the message log view
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            
            } else { // recipient message ui
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(Color(.label))
                    }
                    .padding()
                    .background(Color.green)
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
        MainMessagesView()
//        MessageLogView(appUser: .init(data: ["username" : "syblades"]))
//        NavigationView {
//            MessageLogView(appUser: .init(data: ["username" : "syblades"]))
        //        }

    }

}
