//
//  RankingLineView.swift
//  DRIVLAB
//
//  Created by David Batista on 24/11/2022.
//

import SwiftUI

struct RankingLineView: View {
    var user: User
    @State var isLoggedUser: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .overlay{
                        Circle().stroke(isLoggedUser ? .white: .gray, lineWidth: 2)
                    }
                    .shadow(radius: 3)
                    .padding()
                Text(user.name)
                    .fontWeight(isLoggedUser ? .bold : .regular)
                    .padding()
                Spacer()
                Text(String(user.user_xp) + " XP")
                    .padding()
            }
            Divider()
        }.onAppear{
            isLoggedUser = user.id == User.loggedUserId
        }
    }
}

struct RankingLineView_Previews: PreviewProvider {
    static let previewUser = User.defaultUser()
    static var previews: some View {
        RankingLineView(user: previewUser)
    }
}
