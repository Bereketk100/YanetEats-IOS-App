//
//  InstagramAPIViewController.swift
//  YumsFinalProject
//

//

import UIKit

class FavPostCell: UICollectionViewCell{
    @IBOutlet weak var bac: UIView!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var lab: UILabel!
    
    override func awakeFromNib() {
        bac.layer.cornerRadius = 12
        ima.layer.cornerRadius = 12

    }

}

class FavoriteCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

 
    @IBOutlet weak var collectionView: UICollectionView!
    
    // used for Map
    static var shared = InstagramAPIViewController()

    // singleton data
    var sharedFoodSpots = InstagramAPIModel.shared
    
    // collection view to instantiate the amount of cells

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        
        return sharedFoodSpots.foodSpots.count
    }

    // Data for each collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favPostCell", for: indexPath) as! FavPostCell
        // load image of food spot
        
        if(sharedFoodSpots.foodSpots[indexPath.row].favorite == true) {
            cell.ima.loadFrom(stringUrl: sharedFoodSpots.foodSpots[indexPath.row].media_url!)
            // search up name in hash map using ID
            cell.lab.text = FavoriteCollectionViewController.shared.hashMapFoodData[sharedFoodSpots.foodSpots[indexPath.row].id!]?.name
            
        }


        return cell
    }

    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self

    }


}

// extension used to add image into each cell using URL
   extension UIImageView {
       func loadFromPage(stringUrl: String) {
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


