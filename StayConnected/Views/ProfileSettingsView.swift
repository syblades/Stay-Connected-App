//
//  ProfileSettingsView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import SwiftUI

//setdata func

struct ProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var username = ""
    @State var updatedUsername = ""
    
    // had to set initial value of background in order to change
    init(){
           UITableView.appearance().backgroundColor = .clear
       }
    
    var body: some View {
            VStack {
                Form {
                    DarkModeView()
                    TextField("Update Username", text: $updatedUsername)
                    Button(action: {
                        //func pass uid and updateusername
                        username = updatedUsername
                    }) {
                        Text("Save")
                        
                    }

                        
                        
//                    Text("Update Password")
//                    Text("DELETE ACCOUNT")
//                        .foregroundColor(Color.red)
                }.font(.system(size: 18, weight: .semibold))
                .navigationTitle("User Settings")
            }

    }
    
    
        
}
    

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
