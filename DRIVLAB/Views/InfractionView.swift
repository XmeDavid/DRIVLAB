//
//  MapView.swift
//  TestProject
//
//  Created by David Batista on 08/11/2022.
//

import SwiftUI
import MapKit

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MapView: View {
    
    var infraction: Infraction
    
    @State var coordinateRegion: MKCoordinateRegion = {
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = 0
        newRegion.center.longitude = 0
        newRegion.span.latitudeDelta = 0.2
        newRegion.span.longitudeDelta = 0.2
        return newRegion
    }()
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $coordinateRegion, annotationItems: getAnotations(infraction: infraction)) {item in
                MapMarker(coordinate: item.coordinate)
            }
            VStack{
                HStack{
                    Text(Date.getDate(date: infraction.date))
                    Spacer()
                }
                Spacer()
            }
            
        }.onAppear{
            coordinateRegion.center = infraction.coordinates
        }.navigationTitle(infraction.asString)
    }
    
    func getAnotations(infraction: Infraction) -> [MyAnnotationItem]{
        return [MyAnnotationItem(coordinate: infraction.coordinates)]
    }
}

struct MapView_Previews: PreviewProvider {
    static let infractionPreview = Infraction(
        driveId: "DRIVE-ID",
        date: Date(),
        coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        type: "Type of infraction"
    )
    static var previews: some View {
        MapView(infraction: infractionPreview)
    }
}
