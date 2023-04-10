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
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        
    }
    
    var searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }

    func selectedLocationSearching(localSearch: MKLocalSearchCompletion){
        searchLocation(forLocalSearch: localSearch) { response, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let item = response?.mapItems.first else {return}
            self.selectedLocation = item.placemark.coordinate
        }
    }
    
    func searchLocation(forLocalSearch localSearch: MKLocalSearchCompletion,completion: @escaping (MKLocalSearch.CompletionHandler)){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: completion)
    }

}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
