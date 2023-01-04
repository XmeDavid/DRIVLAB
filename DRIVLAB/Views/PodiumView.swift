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
            alignment: .bottom,
            spacing: 10
        ) {

            SecondPlaceView(user: users[1])
            FirstPlaceView(user: users[0])
            ThirdPlaceView(user: users[2])
            
        }
    }
}

struct PodiumView_Previews: PreviewProvider {
    static var previews: some View {
        PodiumView(users: [])
    }
}

struct FirstPlaceView: View {
    var user: User
    var body: some View {
        VStack {
            Image(systemName: "crown.fill").foregroundColor(.yellow) .scaleEffect(2).offset(y: -10)
            
            VStack{
                
                Image(systemName:"person.crop.circle.fill")
                  .resizable()
                  .frame(width: 128, height: 128)
                  .overlay{
                      Circle().stroke(.white, lineWidth: 2)
                  }
                  .clipShape(Circle())
                Text(user.name)
            }
        }
    }
}

struct SecondPlaceView: View {
    @Environment(\.colorScheme) var colorScheme
    var user: User
    var body: some View {
        VStack{
            Image(systemName: colorScheme  == .dark ? "person.crop.circle.fill" : "person.crop.circle")
              .resizable()
              .frame(width: 64, height: 64)
              .clipShape(Circle())
              .overlay{
                  Image("2nd_place_overlay")
                      .resizable()
              }
            Text(user.name)
        }
    }
}

struct ThirdPlaceView: View {
    @Environment(\.colorScheme) var colorScheme
    var user: User
    var body: some View {
        VStack{
            Image(systemName: colorScheme  == .dark ? "person.crop.circle.fill" : "person.crop.circle")
              .resizable()
              .frame(width: 64, height: 64)
              .clipShape(Circle())
              .overlay{
                  Image("3rd_place_overlay")
                      .resizable()
              }
            Text(user.name)
        }
    }
}

