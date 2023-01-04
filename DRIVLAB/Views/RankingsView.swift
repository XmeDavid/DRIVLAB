//
//  RankingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 24/11/2022.
//

import SwiftUI

struct RankingsView: View {
    
    var users: [User]
    
    var body: some View {
        ScrollView{
            ForEach(users, id:\.self) { user in
                RankingLineView(user: user)
            }
        }
    }
}

struct RankingsView_Previews: PreviewProvider {
    static var previews: some View {
        RankingsView(users: [])
    }
}
