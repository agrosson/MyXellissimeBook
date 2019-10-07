//
//  Map.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import MapKit


// MARK: - Class MapViewController
/**
 This class defines will enable user to locate other users
 */
class MapViewController: UIViewController  {
    
    // MARK: - Outlets and properties
    var usersMap: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let locationManager = CLLocationManager()
    
    let regionInMeters: Double = 5000
    
    var mapAnnotationArray = [MapAnnotation]()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = #colorLiteral(red: 0.2744090557, green: 0.4518461823, blue: 0.527189374, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = color
        let textAttributes = [NSAttributedString.Key.foregroundColor:color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Localisation des utilisateurs"
        checkLocationService()
        view.addSubview(usersMap)
        setupMap()
        
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .locationAuthorization
        }
        
        
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            usersMap.showsUserLocation = true
            centerViewOnUserLocation()
            //Only use this to track movements
            //  locationManager.startUpdatingLocation()
            break
        case .denied:
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .locationAuthorization
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .locationAuthorization
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    // This function will show all users around the current users (10Km)
    func addAnotherUser() {
        fetchUserAnnotation(latitudeUser: 48.859771728515625, longitudeUser: 2.0114145714726535)
        perform(#selector(pinPointAnnotation), with: nil, afterDelay: 3)
    }
    
    // This function display all users
    @objc func pinPointAnnotation(){
        for item in mapAnnotationArray {
            guard let latitute = item.latitude else {return}
            guard let longiture = item.longitude else {return}
            guard let name = item.userName else {return}
            let location = CLLocationCoordinate2D(latitude: latitute, longitude: longiture)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.subtitle = name
            usersMap.addAnnotation(annotation)
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    private func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            // center on user location with regionInMeters distance
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            usersMap.setRegion(region, animated: true)
            addAnotherUser()
        }
        
    }
    
    
    private func setupMap(){
        
        if #available(iOS 11.0, *) {
            usersMap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            usersMap.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            usersMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            usersMap.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            usersMap.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            usersMap.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            usersMap.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        } else {
            usersMap.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true   
        }
        
    }
    //
    func fetchUserAnnotation(latitudeUser: Double, longitudeUser : Double) {
        print("on est ici fetch annotation")
        mapAnnotationArray = [MapAnnotation]()
        let rootRef = Database.database().reference().child(FirebaseUtilities.shared.users)
        rootRef.observe(.childAdded, with: { (snapshot) in
            print("on est ici fetch annotation inside")
            // get the key for the userId
            let userId = snapshot.key
            rootRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                print("on est ici fetch annotation deeper")
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                
                let mapAnnotation = MapAnnotation()
                guard let latitude = dictionary["latitude"] as? Double else {return}
                guard let longitude = dictionary["longitude"] as? Double else {return}
                guard let name = dictionary["name"] as? String else {return}
                guard let profileId = dictionary["profileId"] as? String else {return}
                mapAnnotation.latitude = latitude
                mapAnnotation.longitude = longitude
                mapAnnotation.userName = name
                mapAnnotation.userId = profileId
                print("on est ici fetch annotation deeper 2 \(latitude) \(longitude) \(name) \(profileId))")
                print(mapAnnotation)
                self.mapAnnotationArray.append(mapAnnotation)
            }, withCancel: nil)
        }, withCancel: nil)
        print("fin")
        print(self.mapAnnotationArray)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This not enable zoom
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        // let reg2 = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //  let region3 = MKCoordinateRegion.init(center: center, span: reg2)
        usersMap.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
    
}
