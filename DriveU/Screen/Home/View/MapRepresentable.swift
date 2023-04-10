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
    //let locationManager = LocationManager.shared
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
            context.coordinator.clearAnnotationAndPolyline()
            break
        case .searchingLocation:
            break
        case .locationSelected:
            if let coordinate = locationSearchViewModel.selectedLocation{
                context.coordinator.addAnnotation(destination: coordinate)
                context.coordinator.configurePolyline(destinationCoordinate: coordinate)
            }
            break
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
        var userLocationCoordinate: CLLocationCoordinate2D?
        
        init(parent: MapRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            let region = MKCoordinateRegion(center: center, span: span)
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func addAnnotation(destination:CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = destination
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func clearAnnotationAndPolyline(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion{
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func getRoute(from userLocation: CLLocationCoordinate2D, to destinationLocation: CLLocationCoordinate2D,completion: @escaping (MKRoute) -> ()){
           
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            let direction = MKDirections(request: request)
            direction.calculate { response, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let route = response?.routes.first else {return}
                //print(route.distance)
                completion(route)
            }
            
        }
        func configurePolyline(destinationCoordinate: CLLocationCoordinate2D){
            
            guard let userLocation = userLocationCoordinate else {return}
            getRoute(from: userLocation, to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: UIEdgeInsets(top: 60, left: 35, bottom: 550, right: 35))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            
            return polyline
        }
    }
}
