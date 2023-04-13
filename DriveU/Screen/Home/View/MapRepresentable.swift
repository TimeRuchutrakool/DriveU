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
    @EnvironmentObject var homeViewModel: HomeViewModel
    
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
            context.coordinator.addDriverAnnotation(drivers: homeViewModel.drivers)
            break
        case .searchingLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedLocation?.coordinate{
                context.coordinator.addAnnotation(destination: coordinate)
                context.coordinator.configurePolyline(destinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        case .tripRequesting:
            context.coordinator.clearAnnotationAndPolyline()
            break
        case .tripAccepted:
            guard homeViewModel.currentUser?.accountType == .driver  else {return}
            guard let route = homeViewModel.route else {return}
            guard let trip = homeViewModel.trip else {return}
            context.coordinator.addAnnotation(destination: CLLocationCoordinate2D(latitude: trip.pickUpLocationCoordinate.latitude, longitude: trip.pickUpLocationCoordinate.longitude))
            context.coordinator.configurePolylineToPickUpLocation(route)
            break
        case .driverReject:
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
        
        
        func configurePolyline(destinationCoordinate: CLLocationCoordinate2D){
            
            guard let userLocation = userLocationCoordinate else {return}
            parent.homeViewModel.getRoute(from: userLocation, to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapViewState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: UIEdgeInsets(top: 60, left: 35, bottom: 550, right: 35))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func configurePolylineToPickUpLocation(_ route: MKRoute){
            self.parent.mapView.addOverlay(route.polyline)
            let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 60, left: 32, bottom: 400, right: 32))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            
            return polyline
        }
        
        func addDriverAnnotation(drivers: [User]){
            let annotations = drivers.map({DriverAnnotation(driver: $0)})
            self.parent.mapView.addAnnotations(annotations)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotationDriver = annotation as? DriverAnnotation{
                let view = MKAnnotationView(annotation: annotationDriver, reuseIdentifier: "driver")
                view.image = UIImage(systemName: "car.circle.fill")?.withTintColor(.cyan).withRenderingMode(.alwaysOriginal)
                return view
            }
            return nil
        }
    }
}
