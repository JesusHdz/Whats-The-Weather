import Foundation

/*
 IN ORDER FOR DECODING TO WORK, PROPERTIES MUST BE NAMED EXACTLY AS THEY ARE IN JSON DATA AND PATH
 IN ORDER FOR DECODING TO WORK, PROPERTIES MUST BE NAMED EXACTLY AS THEY ARE IN JSON DATA AND PATH
 IN ORDER FOR DECODING TO WORK, PROPERTIES MUST BE NAMED EXACTLY AS THEY ARE IN JSON DATA AND PATH
 IN ORDER FOR DECODING TO WORK, PROPERTIES MUST BE NAMED EXACTLY AS THEY ARE IN JSON DATA AND PATH
 IN ORDER FOR DECODING TO WORK, PROPERTIES MUST BE NAMED EXACTLY AS THEY ARE IN JSON DATA AND PATH
*/

//Decodable means that it can decode itself from the external representation, in this case, the JSON representation
struct WeatherData: Codable { //Codable is both Decodable and Encoodable protocols into one protocol
    let name: String
    let main: Main //main is an object in JSON data then we must make it into an object here aswell
    let weather: [Weather] //JSON data has an array of weather data types,
}

//Decodable means that it can decode itself from the external representation, in this case, the JSON representation
struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int //id is used to determine type of weather, is used to show certain SF icons
}
