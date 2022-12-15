//
//  ActivityDetailsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct DriveDetailsView: View {
    
    var drive: Drive
    
    @ObservedObject var infractionsModel = InfractionViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Report from " + Date.getDate(date:drive.startDate))
                .font(.title)
                .padding()
            Divider()
            HStack{
                Spacer()
                VStack{
                    Text("Average Speed")
                        .font(.caption)
                    Gauge(value: drive.averageSpeed, in:0...120){
                        Text("Km/h")
                    }currentValueLabel: {
                        Text("\(drive.averageSpeed, specifier: "%.2f")")
                    }
                    .gaugeStyle(.accessoryCircular)
                }.padding()
                VStack{
                    Text("Top Speed")
                        .font(.caption)
                    Gauge(value: drive.topSpeed, in:0...200){
                        Text("Km/h")
                    }currentValueLabel: {
                        Text("\(drive.topSpeed, specifier: "%.1f")")
                    }
                    .gaugeStyle(.accessoryCircular)
                }.padding()
                VStack{
                    Text("Distance")
                        .font(.caption)
                    Gauge(value: drive.averageSpeed, in:0...500){
                        Text("Km")
                    }currentValueLabel: {
                        Text("\(drive.distance, specifier: "%.2f")")
                    }
                    .gaugeStyle(.accessoryCircular)
                }.padding()
                Spacer()
            }
            
            
            
            
            List{
                Section(header: Text("\(infractionsModel.infractions.count) Infractions")){
                    ForEach(infractionsModel.infractions){ infraction in
                        NavigationLink(infraction.asString){
                            MapView(infraction: infraction )
                        }
                    }
                }
            }
            
            
            
        }
            .onAppear{
                print("Drive: \(drive.id)")
                infractionsModel.fetchData(driveId: drive.id)
                infractionsModel.infractions.forEach{ inf in
                    print(inf)
                }
            }
    }
}

struct DriveDetailsView_Previews: PreviewProvider {
    
    static let drivePreview = Drive(
            id: "0",
            user_id: "User #0",
            startDate: Date(),
            infractionsMade: 0,
            averageSpeed: 0.0,
            topSpeed: 0.0,
            distance: 0.0
        )
    
    static var previews: some View {
        DriveDetailsView(drive: drivePreview)
    }
}
