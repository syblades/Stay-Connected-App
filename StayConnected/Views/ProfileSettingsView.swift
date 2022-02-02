//
//  ProfileSettingsView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import SwiftUI



struct ProfileSettingsView: View {
    
    
    // had to set initial value of background in order to change
    init(){
           UITableView.appearance().backgroundColor = .clear
       }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    Form {
                        DarkModeView()
                        Text("Update Username")
                        Text("Update Password")
                        Text("DELETE ACCOUNT")
                            .foregroundColor(Color.red)
                    }.font(.system(size: 18, weight: .semibold))
                    .navigationTitle("User Settings")
                    .padding(.vertical)

                }

            }

        }.background(Color(.label))
        
    }
        
}
    

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
