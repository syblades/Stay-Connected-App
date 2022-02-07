//
//  DarkModeView.swift
//  StayConnected
//
//  Created by Symone Blades on 2/1/22.
//

import SwiftUI


struct DarkModeView: View {
    @State var darkMode: Bool = false
    @State var currentMode: ColorScheme = .light
    var body: some View {
        VStack {
            Toggle("Enable Dark Mode", isOn: $darkMode)
                .onChange(of: darkMode) { value in
                    if darkMode == true {
                        currentMode = .dark
                    } else {
                        currentMode = .light
                    }

                }
        }.preferredColorScheme(currentMode)
//        .labelsHidden()
}
}
struct DarkModeView_Previews: PreviewProvider {
    static var previews: some View {
        DarkModeView()
    }
}
