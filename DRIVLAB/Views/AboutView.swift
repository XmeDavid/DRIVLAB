//
//  AboutView.swift
//  DRIVLAB
//
//  Created by David Batista on 17/11/2022.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Text("This application was made under MEI-CM")
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
    }
        
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
