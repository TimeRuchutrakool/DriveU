//
//  HomeViewModel.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import MapKit

class HomeViewModel: NSObject,ObservableObject{
    
    private let userService = UserService.shared
    @Published var drivers = [User]()
    @Published var currentUser: User?
    private var cancellable = Set<AnyCancellable>()
    @Published var trip: Trip?
    @Published var route: MKRoute?
    
    override init(){
        super.init()
        fetchUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - User
    
    func fetchUser(){
        userService.$user.sink { user in
            guard let user = user else {return}
            self.currentUser = user
            
            if user.accountType == .passenger{
                self.fetchDriver()
                self.tripObserverForPassenger()
            }
            else{
                self.tripObserverForDriver()
            }
            
        }.store(in: &cancellable)
    }
    
    func updateTripState(_ state: TripState){
        guard let trip = trip else {return}
        
        var data = ["state": state.rawValue]
        if state == .tripAccepted{
            data["travelTimeToPassenger"] = trip.travelTimeToPassenger
        }
        
        Firestore.firestore().collection("trips").document(trip.id).updateData(data){ _ in
            print("Trip State: \(state)")
        }
        
    }
    
    func deletedTrip(){
        guard let trip = trip else {return}
        Firestore.firestore().collection("trips").document(trip.id).delete{ _ in
            print("deleted")
            self.trip = nil
        }
    }
    
    //MARK: - Passenger API
    
    func fetchDriver(){
        Firestore.firestore().collection("users").whereField("accountType", isEqualTo: AccountType.driver.rawValue).getDocuments { snapshot, error in
            if let error = error{
                print(error)
                return
            }
            guard let snapshot = snapshot?.documents else {return}
            let drivers = snapshot.compactMap({ try? $0.data(as: User.self)})
            self.drivers = drivers
        }
    }
    
    func closestDriver() -> User?{
        
        guard let currentUserCoordinate = currentUser?.coordinate else {return nil}
       
        let closetDriver = drivers.min(by: {CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: CLLocation(latitude: currentUserCoordinate.latitude, longitude: currentUserCoordinate.longitude)) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: CLLocation(latitude: currentUserCoordinate.latitude, longitude: currentUserCoordinate.longitude))})
        
        return closetDriver
    }
    
    func requestTrip(){
        
        guard let currentUser = currentUser else {return}
        guard let driver = closestDriver() else { return}
        guard let dropOffLocation = selectedLocation else {return}
        let tripCost = computeRidePrice(type: .regular)
        
        let userLocation = CLLocation(latitude: currentUser.coordinate.latitude, longitude: currentUser.coordinate.longitude)
        
        getLocationPlacemark(location: userLocation) { placemark, _ in
            
            guard let placemark = placemark else {return}
            
            let trip = Trip(
                passengerUid: currentUser.uid,
                passengerName: currentUser.username,
                passengerCoordinate: currentUser.coordinate,
                driverUid: driver.uid,
                driverName: driver.username,
                driverCoordinate: driver.coordinate,
                pickUpLocationName: placemark.name ?? "",
                pickUpLocationAddress: self.addressFromPlacemark(placemark: placemark),
                pickUpLocationCoordinate: currentUser.coordinate,
                dropOffLocationName: dropOffLocation.title,
                dropOffLocationAddress: dropOffLocation.subtitle,
                dropOffLocationCoordinate: GeoPoint(latitude: dropOffLocation.coordinate.latitude, longitude: dropOffLocation.coordinate.longitude),
                tripCosts: tripCost,
                distanceToPassenger: 0,
                travelTimeToPassenger: 0,
                state: .tripRequested
            )
            
            guard let encodedData = try? Firestore.Encoder().encode(trip) else {return}
            Firestore.firestore().collection("trips").document().setData(encodedData){_ in
                print("Requesting Succeeded")
            }
        }
    }
    
    func tripObserverForPassenger(){
        guard let uid = currentUser?.uid,currentUser?.accountType == .passenger else {return}
        
        Firestore.firestore().collection("trips").whereField("passengerUid", isEqualTo: uid).addSnapshotListener { snapshot, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let changes = snapshot?.documentChanges.first,changes.type == .added || changes.type == .modified else {return}
            guard let trip = try? changes.document.data(as: Trip.self) else {return}
            self.trip = trip
        }
    }
    
    //MARK: - Driver API
    
    func tripObserverForDriver(){
        guard let uid = currentUser?.uid, currentUser?.accountType == .driver else {return}
        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: uid).addSnapshotListener { snapshot, error in
            if let error = error{
                print(error.localizedDescription)
                    return
            }
            guard let changes = snapshot?.documentChanges.first,changes.type == .added || changes.type == .modified else {return}
            guard let trip = try? changes.document.data(as: Trip.self) else {return}
            self.trip = trip
            
            self.getRoute(from: CLLocationCoordinate2D(latitude: trip.driverCoordinate.latitude, longitude: trip.driverCoordinate.longitude), to: CLLocationCoordinate2D(latitude: trip.passengerCoordinate.latitude, longitude: trip.passengerCoordinate.longitude)) { route in
                self.trip?.distanceToPassenger = route.distance / 1600
                self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime/60)
            }
        }
    }
    
    func acceptTrip(){
        updateTripState(.tripAccepted)
    }
    
    func rejectTrip(){
        updateTripState(.tripRejected)
        deletedTrip()
    }
    
    //MARK: - LocationSearch
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: Location?
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    
    var searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    func getLocationPlacemark(location: CLLocation, completion: @escaping (CLPlacemark?,Error?) -> Void){
        CLGeocoder().reverseGeocodeLocation(location){ placemarks,error in
            if let error = error{
                print(error)
                return
            }
            guard let placemark = placemarks?.first else { return}
            completion(placemark,nil)
        }
    }
    
    func addressFromPlacemark(placemark:CLPlacemark) -> String{
        
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare{
            result += thoroughfare
        }
        if let subthoroughfare = placemark.subThoroughfare{
            result += subthoroughfare
        }
        if let administrativeArea = placemark.administrativeArea{
            result += administrativeArea
        }
        
        return result
    }
    
    func selectedLocationSearching(_ localSearch: MKLocalSearchCompletion){
        searchLocation(forLocalSearch: localSearch) { response, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let item = response?.mapItems.first else{ return }
            let coordinate = item.placemark.coordinate
            self.selectedLocation = Location(title: localSearch.title,subtitle: localSearch.subtitle ,coordinate: coordinate)
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
        let destination = CLLocation(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude)
        
        let distances = start.distance(from: destination)
        
        return type.computePrice(distance: distances)
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
            self.route = route
            self.configurePickUpTimeAndDropOffTime(expectedTime: route.expectedTravelTime)
            completion(route)
        }
        
    }
    
    func configurePickUpTimeAndDropOffTime(expectedTime: TimeInterval){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        pickUpTime = dateFormatter.string(from: Date())
        dropOffTime = dateFormatter.string(from: Date() + expectedTime)
    }
    
}

extension HomeViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
