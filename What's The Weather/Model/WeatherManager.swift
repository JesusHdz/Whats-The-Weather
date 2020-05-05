/*
 PROTOCOLS ARE CREATED IN THE SAME FILE WHERE THE PROTOCOLS WILL BE USED!!!
 PROTOCOLS ARE CREATED IN THE SAME FILE WHERE THE PROTOCOLS WILL BE USED!!!
 PROTOCOLS ARE CREATED IN THE SAME FILE WHERE THE PROTOCOLS WILL BE USED!!!
 PROTOCOLS ARE CREATED IN THE SAME FILE WHERE THE PROTOCOLS WILL BE USED!!!
 PROTOCOLS ARE CREATED IN THE SAME FILE WHERE THE PROTOCOLS WILL BE USED!!!
 */

import Foundation
import CoreLocation //CLLocationDegrees needs CoreLocation imported here

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=05ecae2398aac9e9acf050242d218fed&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        //Step 1
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!) //self must be added since it is inside a closure
                    return
                }
                if let safeData = data {
                    //add self when calling method from current class
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather) //WeatherManager calls itself and must be added as a parameter, so i
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder() //Initializing a decoder that comes from the JSONDecoder object
        do {
            //.decode returns/create a WeatherData object
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //.decode throws so it must follow the "try and catch" format. Parameters include class data type
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
