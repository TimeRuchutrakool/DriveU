//
//  MapRepresentable.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI
import MapKit

struct MapRepresentable: UIViewRepresentable {
    
    var mapView = MKMapView()
    let locationManager = LocationManager()
    @Binding var mapViewState: MapViewState
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapViewState {
        case .noInput:
            context.coordinator.clearAnnotation()
        case .searchingLocation:
            break
        case .locationSelected:
            if let coordinate = locationSearchViewModel.selectedLocation{
                context.coordinator.addAnnotation(destination: coordinate)
            }
        }
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

extension MapRepresentable{
    class Coordinator: NSObject,MKMapViewDelegate{
        
        var parent: MapRepresentable
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MapRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            let region = MKCoordinateRegion(center: center, span: span)
            currentRegion = region
            self.parent.mapView.setRegion(region, animated: true)
        }
        
        func addAnnotation(destination:CLLocationCoordinate2D){
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = destination
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func clearAnnotation(){
            self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            if let currentRegion = currentRegion{
                self.parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
