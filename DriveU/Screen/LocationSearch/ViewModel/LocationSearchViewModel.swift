//
//  LocationSearchViewModel.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject,ObservableObject{
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: CLLocationCoordinate2D?
    var searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
   
    
    func selectedLocationSearching(_ localSearch: MKLocalSearchCompletion){
        searchLocation(forLocalSearch: localSearch) { response, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let item = response?.mapItems.first else{ return }
            let coordinate = item.placemark.coordinate
            self.selectedLocation = coordinate
        }
    }
    
    func searchLocation(forLocalSearch localSearch: MKLocalSearchCompletion,completion: @escaping (MKLocalSearch.CompletionHandler)){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(type: RideType) -> Double{
        guard let selectedLocation = selectedLocation else {return 0.0}
        guard let userLocation = userLocation else {return 0.0}
        
        let start = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        
        let distances = start.distance(from: destination)
        
        return type.computePrice(distance: distances)
    }
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
