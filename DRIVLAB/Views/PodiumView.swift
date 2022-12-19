//
//  PodiumView.swift
//  DRIVLAB
//
//  Created by David Batista on 17/11/2022.
//

import SwiftUI

struct PodiumView: View {
    
    @State var users: [User]
    
    @State private var isLoading = false
    

    var body: some View {
    
        HStack(
            alignment: .top,
            spacing: 10
        ) {
            ForEach(
                0...2,
                id: \.self
            ) { el in
                Group {
                    if (el == 1)
                     {
                        VStack {
                            Image(systemName: "crown.fill").foregroundColor(.yellow) .scaleEffect(2).offset(y: -10)
                            
                            ZStack{
                                Image(systemName: "person.fill")
                                  .resizable()
                                  .frame(width: 128, height: 128)
                                  .foregroundColor(.white)
                                  .padding(20)
                                  .background(Color.blue)
                                  .clipShape(Circle())
                                Text(users[el].name.description + users[el].user_xp.description)
                            }
                        }
                     }
                     else
                     {
                         ZStack{
                             Image(systemName: "person.fill")
                               .resizable()
                               .frame(width: 32, height: 32)
                               .foregroundColor(.white)
                               .padding(20)
                               .background(Color.green)
                               .clipShape(Circle())
                             Text(users[el].name.description + users[el].user_xp.description).offset(y:25)
                         }.offset(y: 85)
                     }
               }
            }
        }.onAppear{users = handleUsers(users: users)}
    }
}

struct PodiumView_Previews: PreviewProvider {
    static var previews: some View {
        PodiumView(users: [])
    }
}

func handleUsers(users: [User]) -> [User]{
    
    var sortedUsers = users.sorted {
        $0.user_xp > $1.user_xp
    }
    
    //sortedUsers[1].user_xp += 50
    
    sortedUsers.swapAt(0, 1)
    
    return sortedUsers
}


