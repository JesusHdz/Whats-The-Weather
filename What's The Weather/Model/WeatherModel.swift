//
//  WeatherModel.swift
//  What's The Weather
//
//  Created by Jesus Hernandez on 4/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //An example of a Computed Property
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    //Computed Property, must always be a var since value can change, must have a data type, curly brackets that returns an output
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
