//
//  ProfileStatsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ProfileStatsView: View {
    
    var user: User
    
    var body: some View {
        VStack(){
            HStack{
                Text("Level:")
                    .font(.body)
                Text("\(user.level)")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("XP:")
                    .font(.body)
                Text("\(user.user_xp)")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Total Distance:")
                    .font(.body)
                Text("\(user.distance_driven, specifier: "%.1f") Km")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Total Infractions Made:")
                    .font(.body)
                Text("\(user.total_infractions)")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Perfect Drives:")
                    .font(.body)
                Text("\(user.perfect_drives)")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Longest Perfect Day Streak:")
                    .font(.body)
                Text("\(user.longest_streak)")
                    .font(.headline)
                Spacer()
            }
        }.padding()
    }
}

struct ProfileStatsView_Previews: PreviewProvider {
    static let user_preview = User.defaultUser()
    static var previews: some View {
        ProfileStatsView(user: user_preview)
    }
}
