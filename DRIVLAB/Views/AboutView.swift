//
//  AboutView.swift
//  DRIVLAB
//
//  Created by David Batista on 17/11/2022.
//

import SwiftUI


struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        ScrollView {
            VStack{
                Image(colorScheme  == .dark ? "logo-white" : "logo-black")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Developed By:")
                    .font(.title)
                Text("David Batista")
                    .font(.largeTitle)
                Text("Frederico Carvalho")
                    .font(.largeTitle)
                Text("Ivan Silva")
                    .font(.largeTitle)
                Spacer()
                    .frame(height: 32)
                Text("This project was done under the Master:")
                Text("Computer Engineering – Mobile Computing")
    
                Image("ipl-logo")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Image("yolov5-logo")
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
        }
        
    }
        
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
