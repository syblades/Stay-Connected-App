//
//  ToggleOption.swift
//  StayConnected
//
//  Created by Symone Blades on 1/31/22.
//

import SwiftUI

struct ToggleOption: View {
    
    @State var modeName = "Light Mode"
    @State var color = ColorScheme.light
    @State var x = true
    

    var body: some View {
        VStack {
            Button (
                 action: {
                     if x == true {
                         modeName = "Dark Mode"
                         color = .dark
                         self.x.toggle()
                     }
                     else {
                         modeName = "Light Mode"
                         color = .light
                         self.x.toggle()
                     }
                 },
                 
                 label: {
                     Spacer()
                     Text("Enable Dark mode")
                         .font(.system(size: 12))
                         .foregroundColor(Color(.label))
                         .offset(x:-12)
                     
                     Image(systemName: "togglepower")
                         .foregroundColor(.white)
                         .font(.system(size: 16, weight: .bold))
                         .padding(5)
                         .background(Color(.label))
                         .cornerRadius(90)
                         .offset(x:-12)
  
                 }
        
             )
            
            Spacer()
        }
  
       .preferredColorScheme(color)
    }
}

            
struct ToggleOption_Previews: PreviewProvider {
    static var previews: some View {
        ToggleOption()
    }
}
