//
//  ActivityDetailsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI
import CoreLocation
import _MapKit_SwiftUI

struct DriveDetailsView: View {
    
    var drive: Drive
    
    @ObservedObject var infractionsModel = InfractionViewModel()
    
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        VStack(alignment: .leading){
            //render()
            Text("Report from " + drive.startDate.dateTimeString)
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
            infractionsModel.fetchData(driveId: drive.id)
        }
        .toolbar{
            ShareLink("Export",
                      item: render(),
                      preview: SharePreview(Text("Shared image"), image: render())
            )
        }
    }
    
    
    
    func render() -> Image{
        let renderer = ImageRenderer(content: SharableImageView(drive: drive, infractions: infractionsModel.infractions))
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo")
    }
}

struct DriveDetailsView_Previews: PreviewProvider {
    
    static let drivePreview = Drive(
            id: "0",
            user_id: User.loggedUserId,
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


struct SharableImageView: View {
    @State var drive: Drive
    @State var infractions: [Infraction]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 39.0,
            longitude: -8
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.2,
            longitudeDelta: 0.2
        )
    )
    
    var infraction = Infraction(driveId: "Drive ID", date: Date(), coordinates: CLLocationCoordinate2D(latitude:0, longitude:0), type: "stop sign")

    var body: some View {
        VStack{
            Text("Drive from \(drive.startDate.dateString)")
                .font(.title)
                .padding()
            HStack {
                Text("Drive XP: ")
                Text("\(Drive.computeXP(drive: drive)) XP")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
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
                    Text("Distances")
                        .font(.caption)
                    Gauge(value: drive.averageSpeed, in:0...500){
                        Text("Km!")
                    }currentValueLabel: {
                        Text("\(drive.distance, specifier: "%.2f")")
                    }
                    .gaugeStyle(.accessoryCircular)
                }.padding()
                Spacer()
            }.onAppear{
                print(infractions.count)
            }
            ForEach(infractions) { infraction in
                Divider()
                HStack{
                    infraction.image
                        .padding()
                    Text(infraction.time)
                    Text("-\(infraction.xp_dif) XP")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            Divider()
            HStack{
                Text("Gained XP: ")
                Text("\(Drive.computeXP(drive: drive, infractions: infractions)) XP")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
            }
            
        }.background(.white
            //Gradient Ideas
            //AngularGradient(stops: [.init(color: .black, location: 0),.init(color: .mint, location: 1)],center: .bottom)
            //AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), center: .bottom, startAngle: .degrees(90), endAngle: .degrees(360 + 360)).offset(y:32)
        )
    }
}
