//
//  InstagramAPIViewController.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 11/29/22.
//

import UIKit
import CoreLocation
import SafariServices

class InstagramAPIViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    // used for Map
    static var shared = InstagramAPIViewController()

    // used to find current location
    let locationManager = CLLocationManager()
    private var currenLoc : CLLocation!
    // singleton data
    var sharedFoodSpots = InstagramAPIModel.shared
    
    // used to find additional information about each food spot object using ID
    var hashMapFoodData = [String : foodData]()
    
    // used to set gestures
    @IBOutlet weak var collectionView: UICollectionView!

    // collection view to instantiate the amount of cells
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedFoodSpots.foodSpots.count
    }
    
    // Data for each collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        // load image of food spot
        cell.image.loadFrom(stringUrl: sharedFoodSpots.foodSpots[indexPath.row].media_url!)
        
        // search up name in hash map using ID
        let foodSpotName = hashMapFoodData[sharedFoodSpots.foodSpots[indexPath.row].id!]?.name
        cell.pTitle.text = foodSpotName
    
        if sharedFoodSpots.foodSpots[indexPath.row].distanceFromCurrent! >= 0{
            cell.pAuthor.text = String(format: "%.1f", sharedFoodSpots.foodSpots[indexPath.row].distanceFromCurrent!) + " mi"
        } else {
            cell.pAuthor.text = " "
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        locationManager.delegate = self
        currenLoc = locationManager.location
        getUserLocation()
        // init hashMap and set distance
        initIds(calDis: true)
        sortBasedOnDistance()
        // tap on cell
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        

    }
    
    // tap gesture for each cell to navigate to IG post
    @objc func tap(sender: UITapGestureRecognizer){
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            _ = self.collectionView?.cellForItem(at: indexPath)
            let vc = SFSafariViewController(url: URL(string: sharedFoodSpots.foodSpots[indexPath.row].permalink!)!)
            present(vc, animated: true)
            sharedFoodSpots.foodSpots[indexPath.row].favorite = true
        }
    }

    
    //Instagram API data does not contain name or coordinates of each food spot so we will use a hashmap based on ID to Instantiate those fields
    func initIds(calDis: Bool) {
        
        let foodDataSouvla = foodData(name: "Souvla", lat: 37.776100, long: -122.426361)
        hashMapFoodData["17992900756573162"] = foodDataSouvla
        
        let foodDataMarcell = foodData(name: "Marcell Von Berlin", lat: 34.082020, long: -118.380650)
        hashMapFoodData["17958314717017529"] = foodDataMarcell
        
        let foodDataYeems = foodData(name: "Yeems Coffee", lat: 34.064130, long: -118.288050)
        hashMapFoodData["17946356867248058"] = foodDataYeems
        
        let foodDataPublic = foodData(name: "Public", lat: 25.267410, long: 55.292680)
        hashMapFoodData["18234106183127892"] = foodDataPublic
        
        let foodDataRachel = foodData(name: "Rachel Ginger Beer", lat: 47.662510, long: -122.299690)
        hashMapFoodData["17940165002469833"] = foodDataRachel
        
        let foodDataEnssaro = foodData(name: "Enssaro Ethiopia", lat: 37.808760, long: -122.255850)
        hashMapFoodData["17922115763537842"] = foodDataEnssaro
        
        let foodDataMemory = foodData(name: "Memory Look", lat: 34.052900, long: -118.297240)
        hashMapFoodData["17912319992621109"] = foodDataMemory
        hashMapFoodData["17985482602603282"] = foodDataMemory
        
        let foodDataLaveta = foodData(name: "Laveta", lat: 34.066120, long: -118.260178)
        hashMapFoodData["17925843956407389"] = foodDataLaveta
        
        let foodDataKitchen = foodData(name: "Kitchen Story", lat: 37.840700, long: -122.251200)
        hashMapFoodData["17954938705705255"] = foodDataKitchen
        hashMapFoodData["17917927868170336"] = foodDataKitchen
        
        let foodDataPalms = foodData(name: "Palms", lat: 37.225015, long: -121.983089)
        hashMapFoodData["17961432385614361"] = foodDataPalms
        
        let foodDataIkoi = foodData(name: "Ikoi Sushi", lat: 38.013100, long: -122.559460)
        hashMapFoodData["18260005744072315"] = foodDataIkoi
        
        let foodDataDulce = foodData(name: "Dulce", lat: 34.026550, long: -118.285301)
        hashMapFoodData["18002570269406499"] = foodDataDulce
        
        let foodDataLe = foodData(name: "Le Grand", lat: 34.047220, long: -118.256710)
        hashMapFoodData["17979717055448516"] = foodDataLe
        
        let foodDataBottega = foodData(name: "Bottega Louie", lat: 34.047250, long: -118.256540)
        hashMapFoodData["17922934310232219"] = foodDataBottega
        hashMapFoodData["17895926018541597"] = foodDataBottega
        
        let foodDataMet = foodData(name: "Met Her At A Bar", lat: 34.060500, long: -118.344730)
        hashMapFoodData["17949131935743304"] = foodDataMet
        
        let foodDataLuna = foodData(name: "Luna Blu", lat: 37.873060, long: -122.456690)
        hashMapFoodData["17938451023778288"] = foodDataLuna
        
        let foodDataFox = foodData(name: "Fox & Knit", lat: 37.974030, long: -122.530810)
        hashMapFoodData["18221717419105618"] = foodDataFox
        
        let foodDataPlanet = foodData(name: "Planet Juice", lat: 37.969500, long: -122.516500)
        hashMapFoodData["17906333030432832"] = foodDataPlanet
        
        let foodDataCal = foodData(name: "California Kitchen", lat: 37.325520, long: -121.945648)
        hashMapFoodData["18153918262211890"] = foodDataCal
        
        let foodDataWater = foodData(name: "Coffe & Water Lab", lat: 37.315610, long: -121.976590)
        hashMapFoodData["17946247192702032"] = foodDataWater
        
        let foodDataBerri = foodData(name: "Berri's Cafe", lat: 47.607380, long: 122.339150)
        hashMapFoodData["17912862665186172"] = foodDataBerri
        
        let foodDataCrepevine = foodData(name: "Crepevine", lat: 37.764260, long: -122.464680)
        hashMapFoodData["17904781919268208"] = foodDataCrepevine
        
        if (calDis == true) {
            setCurrentDistance()
        }
        
    }

    // gets users current location
    func getUserLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
    // prints error if unable to get location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    // sets location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currenLoc = locations.first
    }
    
    // sets distance of each foodSpot object using hashMap
    func setCurrentDistance() {
        locationManager.requestLocation()
        sharedFoodSpots.foodSpots.forEach { food  in
            let lat = hashMapFoodData[food.id!]?.lat
            let long = hashMapFoodData[food.id!]?.long
            
            let coordinate1 = CLLocation(latitude: lat!, longitude: long!)
            var distanceInMeters = -1.0
            if(currenLoc != nil) {
                distanceInMeters = currenLoc.distance(from: coordinate1)
            }
            
            let distanceInMiles = distanceInMeters*0.000621371192
            food.setDistance(distance: distanceInMiles)
        }
    }
    
    // sorts each foodSpot object based on distance from current user
    func sortBasedOnDistance() {
        self.sharedFoodSpots.foodSpots.sort(by: {$0.distanceFromCurrent ?? 0.0 < $1.distanceFromCurrent ?? 0.0})
    }

}

// extension used to add image into each cell using URL
   extension UIImageView {
       func loadFrom(stringUrl: String) {
           if let url = URL(string: stringUrl) {
           URLSession.shared.dataTask(with: url) { (data, response, error) in
               // URL session used to return data which is an UIImage
               
             // Error handling
             guard let imageData = data else { return }

            // Submits asynchronous execution on a dispatch queue and returns immediately.
             DispatchQueue.main.async {
               self.image = UIImage(data: imageData)
             }
           }.resume()
         }
       }
   }
