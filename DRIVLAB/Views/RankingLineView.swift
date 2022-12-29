//
//  RankingLineView.swift
//  DRIVLAB
//
//  Created by David Batista on 24/11/2022.
//

import SwiftUI

struct RankingLineView: View {
    var user: User
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .overlay{
                        Circle().stroke(.white, lineWidth: 2)
                    }
                    .shadow(radius: 3)
                    .padding()
                Text(user.name)
                    .padding()
                Spacer()
                Text(String(user.user_xp) + " XP")
                    .padding()
            }
            Divider()
        }
    }
}

struct RankingLineView_Previews: PreviewProvider {
    static let previewUser = User(id: "",name: "", email: "", password: "", photo_url: "", user_xp: 0)
    static var previews: some View {
        RankingLineView(user: previewUser)
    }
}
