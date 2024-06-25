//
//  ContentView.swift
//  BucketList
//
//  Created by Godwin IE on 09/06/2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 4.9757, longitude: 8.3417),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var locations = [Location]()
    
    @State private var selectedLocation: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinates) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.blue)
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture{
                                selectedLocation = location
                            }
                    }
                }
            }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        
                        locations.append(newLocation)
                    }
                } //tap gesture
        } //map
        .sheet(item: $selectedLocation) { place in
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }
    }
    

}

#Preview {
    ContentView()
}


//func authenticate() {
//    let context = LAContext()
//    var error: NSError?
//    
//    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//        let reason = "We need to secure your data"
//        
//        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//            if success {
//                isUnlocked = true
//            } else {
//                //there was a problem
//            }
//            
//        }
//        
//    } else {
//        //no biometrics
//    }
//}// func authenticate
