//
//  ContentView.swift
//  StayConnected
//
//  Created by Symone Blades on 1/28/22.
//

import SwiftUI
import Firebase


struct LoginView: View {
    
    let didFinishLogin: () -> () // closure
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State  var username = ""
    
    @State private var shouldShowImagePicker = false
    
   
    var body: some View {
        
        
            
            ScrollView {
               
                VStack(spacing: 16) {
                    
                    // sets create account and login option at top of view
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        // makes 'Create Account' the default state b/c isLoginMode is initially set to false
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                        .overlay(RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color.black, lineWidth: 2))
                       
 
                        
                        .padding()
                        

                    
                    // if they are creating an account this icon will appear
                    if !isLoginMode {
                        // Choose a profile pic icon
                        Button {
                            shouldShowImagePicker.toggle() // everytime user clicks on icon will turn to 'true'
                        } label: {
                            
                            VStack {
                                
                                // sets the image to the image selected or the default person filled
                                if let image = self.image {
                                    // adjusting the picture settings
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 70))
                                        .padding()
                                        .foregroundColor(Color(.black))
                                }
                            }
                            
                            // creates a round border around profile image
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3))

                            .padding()
                        }
                        
                        
                       
                          

                        
                        
                        TextField("", text: $username)
                            .modifier(PlaceholderStyle(showPlaceHolder: username.isEmpty,
                                                       placeholder: "Username"))
                            .foregroundColor(Color.black)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .padding(16)
                            .background(Color(.white))
                            .cornerRadius(8)
                    }
                       


                    
                    // allows me to apply padding and background setting to multiple instances using the 'Group' type

                    Group {
                                                
                        TextField("", text: $email)
                        
                            .modifier(PlaceholderStyle(showPlaceHolder: email.isEmpty,
                                                       placeholder: "Email"))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        // 'SecureField' creates a 'mask' so password isnt visible when user enters
                        SecureField("", text: $password)
                            .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty,
                                                       placeholder: "Password"))
                    }
                    .padding(16)
                    .foregroundColor(Color(.black))
                    .background(Color(.white))
                    .cornerRadius(6)
                    Spacer()
 
                    
                    // Create Account OR Login Button
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account") // logic to update button based on which option is selected
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                
                                .font(.system(size: 18, weight:.semibold))
                            Spacer()
                        }.background(Color.black)
                            .cornerRadius(30)
                            .shadow(radius: 15)
                            .padding()
                    }
                    
                    // displays successfully created user or user already exists message under 'Create Account' button
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            // checking if isLoginMode true meaning if the picker in the nav bar is set to 'Login' else it means it's set to Create Account
            // changes the nav header
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .padding(.top, 8)
//            .padding(.bottom, 10)
            
            
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()) // applies color to entire screen, previously it left out top

        
       
        
        
        //view modifier
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
            
        }
    }
    
    
    public struct PlaceholderStyle: ViewModifier {
        var showPlaceHolder: Bool
        var placeholder: String

        public func body(content: Content) -> some View {
            ZStack(alignment: .leading) {
                if showPlaceHolder {
                    Text(placeholder)
                        .foregroundColor(Color.gray)
                    
                }
                content
                
                
            }
        }
    }
    
    @State var image: UIImage?
    

    // TODO: ADD OTHER LOGIN OPTIONS (GOOGLE, GITHUB etc.)
    private func handleAction() {
        if isLoginMode {
//            print("log in to Firebase w credentials")
            loginUser()
        } else {
            createNewAccount()
//            print("register new account in Firebase Auth and store")
        }
    }
    
    // checks if email and password match user login creds in db
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            self.didFinishLogin()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        
        if self.image == nil {
            self.loginStatusMessage = "You must select a profile photo"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            // need to be logged in to save image to Firebase storage
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData, metadata: nil) {metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Succesfully stored image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else {return} // storing the image is no longer optional
                self.storeUserInfo(imageProfileUrl: url)
            }
        }
    }
    
    func storeUserInfo(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // creating dictionary to establish what data we are saving from the user
        let userData = ["username": self.username, "email": self.email, "uid": uid, "profileImageURL": imageProfileUrl.absoluteString]
        
        // creating collection 'users' in firestore db
        // each document is the users 'uid'
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success!")
                
                self.didFinishLogin()
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didFinishLogin: {

        })
    }
}
