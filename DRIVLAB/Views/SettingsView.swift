//
//  SettingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    private func createUser(){
        UsersViewModel().addData(user: User(
            name: "Joel Simoes",
            email: "example@mail.com",
            password: "1234",
            photo_url: "www.davidsbatista.com/defaults/photo"
        ))
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    NavigationLink("Create User"){
                        Button("Create User", action: createUser)
                    }
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
