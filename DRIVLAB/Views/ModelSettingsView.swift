//
//  ModelSettingsView.swift
//  DRIVLAB
//
//  Created by David Batista on 12/12/2022.
//

import SwiftUI

struct ModelSettingsView: View {
    @AppStorage("visualizeDetections") var visualizeDetections = true
    @AppStorage("showLabels") var showLabels = true
    //@AppStorage("iouThreshold") var iouThreshold = 0.6
    //@AppStorage("confidenceThreshold") var confidenceThreshold = 0.45
    @AppStorage("locationUpdateInterval") var locationUpdateInterval = 0.9
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Detector Settings")){
                    HStack {
                        Toggle(isOn: $visualizeDetections) {
                            Text("Show bounding boxes")
                                .font(.body)
                        }
                    }
                    HStack {
                        Toggle(isOn: $showLabels) {
                            Text("Show labels")
                                .font(.body)
                        }
                    }
                    
                     /*
                    VStack {
                        Slider(value: $confidenceThreshold, in: 0...1)
                        Text("Confidence threshold")
                            .font(.body)
                    }*/
                }
                
                Section(header: Text("Location Settings")){
                    VStack(alignment: .leading){
                        Text("Speed check interval (seconds)")
                            .font(.body)
                        HStack{
                            Text("0.2")
                            Slider(value: $locationUpdateInterval, in: 0.2...2)
                            Text("2")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct ModelSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ModelSettingsView()
    }
}
