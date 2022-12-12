//
//  SettingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("showSpeed") var showSpeed = true
    
    private func createUser(){
        UsersViewModel().addData(user: User(
            name: "Random Name",
            email: "example@mail.com",
            password: "1234",
            photo_url: "www.drivlab.com/defaults/photo"
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
                Section(header: Text("Basic Settings")){
                    HStack(alignment: .center) {
                        Toggle(isOn: $showSpeed) {
                            Text("Show speed")
                                .font(.body)
                        }
                    }
                }
                Section{
                    NavigationLink("Model Settings",destination: ModelSettingsView())
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
