//
//  ViewController.swift
//  554
//
//  Created by Гость on 23.06.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempertureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        // Do any additional setup after loading the view.
    }
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        tempertureLabel.text = weatherData.main.temp.description + "°"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
        
    }
    
    
    func updateWeatherinfo(latitude: Double, longtitude: Double) {
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=62&lon=129&appid=60aaa4e2978a80f695973b70aa22fe1b")!
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                
                }
            }catch {
                    print(error.localizedDescription)
                }
            }
        task.resume()
        }
    }

extension ViewController: CLLocationManagerDelegate {
    func locationManager(  _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherinfo(latitude: lastLocation.coordinate.latitude , longtitude: lastLocation.coordinate.longitude)
        }
    }
}
