//
//  ContentView.swift
//  StayConnected
//
//  Created by Symone Blades on 1/28/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    // sets create account and login option at tope of view
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        // makes 'Create Account' the default state b/c isLoginMode is initially set to false
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())

                    
                    // if they are creating an account this icon will appear
                    if !isLoginMode {
                        // Choose a profile pic icon
                        Button {
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    
                    // allows me to apply padding and background setting to multiple instances using the 'Group' type
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        // 'SecureField' creates a 'mask' so password isnt visible when user enters
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
 
                    
                    // Create Account OR Login Button
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account") // logic to update button based on which option is selected
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 18, weight:.semibold))
                            Spacer()
                        }.background(Color.blue)
                    }
                }
                .padding()
            }
            // checking if isLoginMode true meaning if the picker in the nav bar is set to 'Login' else it means it's set to Create Account
            // changes the nav header
            .navigationTitle(isLoginMode ? "Login" : "Create Your Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea()) // applies color to entire screen, previously it left out top

        }
    }
    
    private func handleAction() {
        if isLoginMode {
            print("log in to Firebase w credentials")
        } else {
            print("register new account in Firebase Auth and store")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
