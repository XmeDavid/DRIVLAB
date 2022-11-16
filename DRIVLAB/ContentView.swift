//
//  ContentView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            LeaderboardView()
                .tabItem{
                    Label("Leaderboard", systemImage: "trophy.circle.fill")
                }
            CameraView()
                .tabItem{
                    Label("DRIVLAB", systemImage: "car.fill")
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
