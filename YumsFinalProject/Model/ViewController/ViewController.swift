//
//  ViewController.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 11/23/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    // location manger for distance purposes
    let locationManager = CLLocationManager()
    private var currenLoc : CLLocation!
    
    
    var sharedFoodSpots = InstagramAPIModel.shared
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {

        
        super.viewDidLoad()
        locationManager.delegate = self
        getUserLocation()
        let colorTop = UIColor(red: 0.87, green: 0.37, blue: 0.54, alpha: 1.00)
        let colorBottom = UIColor(red: 0.97, green: 0.73, blue: 0.59, alpha: 1.00)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgView.bounds

        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)

        if let myImage = UIImage(named: "email"){
            email.withImage(direction: .Right, image: myImage, colorSeparator: colorTop, colorBorder: UIColor.white)
        }

        if let myImage = UIImage(named: "password"){
            Password.withImage(direction: .Right, image: myImage, colorSeparator: colorTop, colorBorder: UIColor.white)
        }
        
        // API call to generate all food spots
        sharedFoodSpots.instagramAPICall()
    }
    
    func getUserLocation() {

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
      }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        currenLoc = locations.first
    }

    
    @IBAction func SignUpTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: Password.text!, completion: {
            (result, error) in
            // if there are no error, go to home page
            if error == nil  {
                self.performSegue(withIdentifier: "homePage", sender: nil)
            } else {
                self.alert()
            }
        })
    }
    @IBAction func LoginTapped(_ sender: Any) {
        print(email.text!)
        print(Password.text!)
        Auth.auth().signIn(withEmail: email.text!, password: Password.text!) { result, error in
            print(error as Any)
            if error == nil {
                self.performSegue(withIdentifier: "homePage", sender: nil)
            } else {
                self.alert()
            }
        }
    }
    
    func addIcon(txtField:UITextField, andimage img:UIImage) {
        let leftimiageview = UIImageView(frame: CGRect(x: 1000.0, y: 1000.0, width: img.size.width, height: img.size.height))
        leftimiageview.image = img
        txtField.rightView = leftimiageview
        txtField.rightViewMode = .always
    }
    
    func alert () {
        let dialogMessage = UIAlertController(title: "Alert", message: "Invalid credentials, try again!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)

    }
    
}



// add image to textfield for login/signup
extension UITextField {

// option to add to left or right
enum Direction {
    case Left
    case Right
}

// add image to textfield for login/signup
func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    view.backgroundColor = .white
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.layer.borderWidth = CGFloat(0.5)
    view.layer.borderColor = colorBorder.cgColor
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
    view.addSubview(imageView)

    let seperatorView = UIView()
    seperatorView.backgroundColor = colorSeparator
    mainView.addSubview(seperatorView)

    if(Direction.Left == direction){ // image left
        seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
        self.rightViewMode = .always
        self.rightView = mainView
    }

    self.layer.borderColor = colorBorder.cgColor
    self.layer.borderWidth = CGFloat(0.5)
    self.layer.cornerRadius = 5
}

}

