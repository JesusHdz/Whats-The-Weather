//
//  ViewController.swift
//  What's The Weather
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation //CoreLocation is used to be able to use GPS

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() //Comes from CoreLocation. Needs Permission Request before being used
    
    override func viewDidLoad() { //Code inside will execute when view loads
        super.viewDidLoad()
        
        //locationManager.delegate = self must be executed before it is used
        locationManager.delegate = self //To get notification for location, WeatherViewController has to be set as delegate for locationManager
        locationManager.requestWhenInUseAuthorization() //Requests the user’s permission to use location services while the app is in use.
        locationManager.requestLocation() //Requests the one-time delivery of the user’s current location.
        
        weatherManager.delegate = self
        //Self refers to current viewController
        //text field should report back to viewController
        searchTextField.delegate = self
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegatte

//extension has to have same name of class in order to extend that class
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != " " {
            return true
        } else {
            textField.placeholder = "Type a location"
            return false
        }
    }
    
    //This is how Apple formats their delegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        //Use searchTextFielf.text to get weather for that city
        searchTextField.text = " "
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    //We will format this delegate method to be more inline to how Apple formats their delegate methods
    //1st thing will be the identity of the object that calls this delegate method, and since our WeatherManager calls this, we will add it
    //2nd thing is to add an emited parameter name
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { //DispatchQueue is used to use UI of an app while networking is being carried out in background
            self.temperatureLabel.text = weather.temperatureString //self must be added since code is inside a closure
            self.conditionImageView.image = UIImage(systemName: weather.conditionName) //UIImage is used since image comes from UIKit. (systemName:) creates an image object containing a system symbol image
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
