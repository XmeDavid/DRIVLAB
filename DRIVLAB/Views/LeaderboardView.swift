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
            if(usersViewModel.users.isEmpty){
                LoadingView()
            } else{
                PodiumView(users:usersViewModel.users)
                ProfileStatsView(user: usersViewModel.user)
                RankingsView(users:usersViewModel.users)
            }
        }.onAppear(){
            usersViewModel.fetchAllUsers()
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

struct LoadingView: View{
    var body: some View{
        ZStack{
            Color(.systemBackground).ignoresSafeArea()
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .green)).scaleEffect(3)
        }
    }
}
