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
    @AppStorage("iouThreshold") var iouThreshold = 0.6
    @AppStorage("confidenceThreshold") var confidenceThreshold = 0.45
    
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
                    /*VStack {
                        Slider(value: $iouThreshold, in: 0...1)
                        Text("IoU threshold")
                            .font(.body)
                    }
                    VStack {
                        Slider(value: $confidenceThreshold, in: 0...1)
                        Text("Confidence threshold")
                            .font(.body)
                    }*/
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
