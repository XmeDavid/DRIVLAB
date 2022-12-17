//
//  PodiumView.swift
//  DRIVLAB
//
//  Created by David Batista on 17/11/2022.
//

import SwiftUI

struct PodiumView: View {
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 10
        ) {
            ForEach(
                1...3,
                id: \.self
            ) { el in
                Group {
                    if (el == 2)
                     {
                        VStack {
                            Image(systemName: "crown.fill").foregroundColor(.yellow) .scaleEffect(2).offset(y: -10)
                        Circle()
                         .fill(.blue)
                         .frame(width: 128, height: 128)
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
                             Text(el == 1 ? "2" : el.description).offset(y:25)
                         }.offset(y: 85)
                     }
               }
            }
        }
    }
}

struct PodiumView_Previews: PreviewProvider {
    static var previews: some View {
        PodiumView()
    }
}
