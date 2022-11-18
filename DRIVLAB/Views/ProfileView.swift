//
//  ProfileView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack(){
                    Image("image")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay{
                            Circle().stroke(.white, lineWidth: 4)
                        }
                        .shadow(radius: 7)
                        .padding()
                    VStack(alignment: .leading){
                        Text("Welcome,")
                            .font(.headline)
                        Text("David Batista").font(.largeTitle)
                    }
                    Spacer()
                }
                Divider()
                ProfileStatsView()
                RecentActivityView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .toolbar{
                NavigationLink(destination: SettingsView()){
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
