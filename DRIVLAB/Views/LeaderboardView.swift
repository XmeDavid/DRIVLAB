//
//  LeaderboardView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct LeaderboardView: View {
    
    @ObservedObject var usersViewModel = UsersViewModel()
    
    var body: some View {
        VStack{
            PodiumView()
            ProfileStatsView()
            RankingsView(users:usersViewModel.users)
        }.onAppear(){
            usersViewModel.fetchData()
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
