//
//  geolocation.swift
//  Weather
//
//  Created by Juho on 6.12.2022.
//

import Foundation
import SwiftUI
import MapKit


class geolocate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 60.22408, longitude: 24.75852),
                                                  span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
    @Published var currentCity = ""
    var fmi = FMI()
    var locationManager: CLLocationManager?
    let geoCoder = CLGeocoder()
    
    //Check if user has set location services off entirely from settings.
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        }else{
            print("No services running")
        }
    }
    
    //Checks Authorizatin level of the app
    private func checkLocationAuth() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied app location permissions. Go into settings to change this setting.")
        case .authorizedAlways, .authorizedWhenInUse:
            guard let coords = locationManager.location?.coordinate else {return}
            print(coords)
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coords.latitude, longitude: (coords.longitude - 0.0050)), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            reverseGeo(lat: coords.latitude, long: coords.longitude)
            
        @unknown default:
            break
        }
    }
    
    // If user has changed the preference of authorization ask again for permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    // Get city / sublocality name based off lat and long coords.^^
    func reverseGeo(lat:Double, long:Double){
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long), completionHandler: { [self]
            
            placemarks, error -> Void in
            guard let placemark = placemarks?.first else {return}
            
            if let city = placemark.locality{
                if let city2 = placemark.subLocality{
                    fmi.getForecast(place: city)
                    currentCity = city2
                    fmi.loc = city2
                    print(city2)
                    
                } else {
                    fmi.getForecast(place: city)
                    currentCity = city
                    fmi.loc = city
                    print(city)
                    print(fmi.loc)
                }
            }
            

            
            
        })
    }
    
    func nameToCoordinates(location:String){
        geoCoder.geocodeAddressString(location, completionHandler: { [self]
            
            placemarks, error -> Void in
            guard let placemark = placemarks?.first else {return}
            let coords = placemark.location!.coordinate
            print("lat \(coords.latitude)")
            print("long \(coords.longitude)")
            
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coords.latitude, longitude: (coords.longitude - 0.0050)), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            fmi.objectWillChange.send()
            //fmi.getForecast(place: location)
            //fmi.loc = location
            currentCity = location
            
        })
    }
    

    
}



