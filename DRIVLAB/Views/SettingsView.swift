//
//  SettingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var randomVar: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    NavigationLink("Activity from ", destination: LeaderboardView())
                    Toggle("Show welcom message", isOn: $randomVar)
                }
                Section{
                    NavigationLink("About", destination: AboutView())
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
