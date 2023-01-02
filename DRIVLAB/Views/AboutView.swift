//
//  AboutView.swift
//  DRIVLAB
//
//  Created by David Batista on 17/11/2022.
//

import SwiftUI


///This whole page can be deleted probably
struct AboutView: View {
    var body: some View {
        VStack{
            Text("About page to leave some random note idk\nWas used to test in the early stages navigation")
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
        
    }
        
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
