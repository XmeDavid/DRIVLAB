//
//  ProfileStatsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ProfileStatsView: View {
    var body: some View {
        VStack(){
            HStack{
                Text("Level:")
                    .font(.body)
                Text("17")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("XP:")
                    .font(.body)
                Text("728364")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Total Distance:")
                    .font(.body)
                Text("3123 Km")
                    .font(.headline)
                Spacer()
            }
            HStack{
                Text("Total Infractions Made:")
                    .font(.body)
                Text("123")
                    .font(.headline)
                Spacer()
            }
        }.padding()
    }
}

struct ProfileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStatsView()
    }
}
