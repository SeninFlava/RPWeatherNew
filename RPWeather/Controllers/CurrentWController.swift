//
//  ViewController.swift
//  RPWeather
//
//  Created by Alexander Senin on 04.10.2021.
//

import UIKit
import CoreLocation

class CurrentWController: UIViewController {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelDegrees: UILabel!
    @IBOutlet weak var imageIconWeather: UIImageView!
    
    @IBOutlet weak var labelError: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
        
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.sharedInstance.requestForLocation {
            self.pushRefreshAction(self)
        }
        pushRefreshAction(self)
    }
    
    
    
    
    
    func updateCurrentWeather() {
        
        self.itemRefresh.isEnabled = false

        LocationManager.sharedInstance.getCurrentLocation { lat, lon in
            self.refreshWeather(lat: lat, lon: lon)
        }
        

    }
    
    func updateWeather(city: City) {
        refreshWeather(lat: city.lat, lon: city.lon)
    }

    
    
    
    func refreshWeather(lat: Double, lon: Double) {
        Model().refreshCurrnetWeatherData(lat: lat, lon: lon) { weatherData, error in
            
            DispatchQueue.main.async {
                self.itemRefresh.isEnabled = true
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.labelError.text = error
                    self.labelCityName.text = "-"
                    self.labelDegrees.text = "-"
                    self.imageIconWeather.image = UIImage()
                }
                return
            }
            
            if let weatherData = weatherData {
                DispatchQueue.main.async {
                    self.labelError.text = ""
                    self.labelCityName.text = weatherData.city
                    self.labelDegrees.text = weatherData.degreesCelsiy
                    self.imageIconWeather.load(url: URL(string: weatherData.iconUrl)!)
                }
            }
        }
    }

    
    
    
    @IBOutlet weak var itemRefresh: UIBarButtonItem!
    @IBAction func pushRefreshAction(_ sender: Any) {
        if let city = selectedCity {
            updateWeather(city: city)
            return
        }
        
        if LocationManager.sharedInstance.isLocationServicesPermitted {
            updateCurrentWeather()
        } else {
            labelError.text = "Allow access to location services for this application"
            labelCityName.text = "-"
            labelDegrees.text = "-"
        }
        
    }
    
    
    
}








extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
