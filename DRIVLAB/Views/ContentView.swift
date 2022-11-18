//
//  ContentView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ContentView: View {
    enum Tab: String, CaseIterable, Identifiable {
        case leaderboard
        case drivlab
        case activity

        var id: Self { self }
    }

    @State private var tab = Tab.drivlab
    
    var body: some View {
        TabView(selection: $tab){
            LeaderboardView()
                .tabItem{
                    Label("Leaderboard", systemImage: "trophy.circle.fill")
                }
                .tag(Tab.leaderboard)
            CameraView()
                .tabItem{
                    Label("DRIVLAB", systemImage: "car.fill")
                }
                .tag(Tab.drivlab)
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(Tab.activity)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
