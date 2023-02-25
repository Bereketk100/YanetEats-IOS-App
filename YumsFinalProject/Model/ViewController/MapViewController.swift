//
//  MapViewController.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 12/7/22.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // hash map that contains name, lat and long
    var sharedLocationAndName = InstagramAPIViewController.shared
    
    // each food spot, we need ID in order to cal name, lat and long
    var sharedFoodSpots = InstagramAPIModel.shared
    
    // apple maps
    var selectedPin : MKPlacemark?
    

    // used to find current location
    let locationManager = CLLocationManager()
    private var currenLoc : CLLocation!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        locationManager.delegate = self
        currenLoc = locationManager.location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        centerLocation()
        
        // set hash map
        sharedLocationAndName.initIds(calDis: false)
        
        var annotations : [MKPointAnnotation] = []
        // search hash map
        sharedFoodSpots.foodSpots.forEach { food  in
            let annotation = MKPointAnnotation()
            let name = sharedLocationAndName.hashMapFoodData[food.id!]?.name
            let lat = sharedLocationAndName.hashMapFoodData[food.id!]?.lat
            let long = sharedLocationAndName.hashMapFoodData[food.id!]?.long
            
            annotation.title = name
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        
        // Do any additional setup after loading the view.
    }
    
    // center around usc
    func centerLocation() {
        let coordinate = CLLocation(latitude: 34.0224, longitude: -118.2851)
        mapView.centerToLocation(coordinate)
        
        let region = MKCoordinateRegion(center: coordinate.coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
    }
    
    // calculature users location
    func getUserLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    // print error if unable to get location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        
    }
    
    //set locaion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currenLoc = locations.first
    }
    
    
    // sets region for current location
    @IBAction func btnPressed(_ sender: Any) {
        mapView.showsUserLocation = true
        locationManager.requestLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let reg = MKCoordinateRegion(center: currenLoc.coordinate, span: span)
        
        mapView.setRegion(reg, animated: true)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.tintColor = UIColor.orange
            pinView?.canShowCallout = true
            
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "food"), for: [])
            button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)

            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
    @objc func getDirections(){
        selectedPin = MKPlacemark(coordinate: mapView.annotations.first!.coordinate)
        let mapItem = MKMapItem(placemark: selectedPin!)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
        }
    
}

// extention that renders map based on location
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 5000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
