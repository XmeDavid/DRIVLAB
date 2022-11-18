//
//  SettingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    
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
