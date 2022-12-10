//
//  FMIParser.swift
//  TestEnvironment
//
//  Created by Teemu on 10.12.2022.
//

import Foundation
class WeatherStatus: Identifiable, ObservableObject {
    let id = UUID()
    var date: Date?
    var humidity: Float?
    var temperature: Float?
    var symbol: String?
    var windDirection: Float?
    var windSpeed: Float?
    
    init(date: Date?) {
        self.date = date
    }
    
    var hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self.date!)
    }
}

enum Identifier: String, CaseIterable {
    case Humidity
    case Temperature
    case WeatherSymbol3
    case WindDirection
    case WindSpeedMS
}

class FMIParser: NSObject, XMLParserDelegate {
    private var currentElement: String?
    private var currentIdentifier: Identifier?
    private var currentDate: Date?
    private let dateFormatter = ISO8601DateFormatter()
    
    var data = [WeatherStatus]()
    
    // element start
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElement = elementName
        if elementName == "wml2:MeasurementTimeseries" {
            // example of an ID to be parsed: mts-1-1-WeatherSymbol3
            let id = attributeDict["gml:id"]?.components(separatedBy: "-").last
            self.currentIdentifier = Identifier(rawValue: id!)
        }
    }
    
    // element end
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentElement = nil
    }
    
    // element value
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.currentElement == nil || self.currentIdentifier == nil {
            return
        }

        let s = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if currentElement == "wml2:time" {
            self.currentDate = self.dateFormatter.date(from: s)!
            let weatherStatus = self.data.first(where: {$0.date == self.currentDate})
            if weatherStatus == nil {
                self.data.append(WeatherStatus(date: self.currentDate))
            }
            return
        }

        if (currentElement != "wml2:value") {
            return
        }
        
        let value = Float(s)
        let weatherStatus = self.data.first(where: {$0.date == self.currentDate})

        switch self.currentIdentifier {
        case .Humidity:
            weatherStatus?.humidity = value
        case .Temperature:
            weatherStatus?.temperature = value
        case .WeatherSymbol3:
            weatherStatus?.symbol = GetSymbol(value!)
        case .WindDirection:
            weatherStatus?.windDirection = value
        case .WindSpeedMS:
            weatherStatus?.windSpeed = value
        default:
            break
        }
    }
}

func GetSymbol(_ value: Float) -> String {
    switch value {
    case 1.0:
        return "sun.fill"
    case 2.0:
        return "cloud.sun.fill"
    case 3.0:
        return "cloud.fill"
    case 31.0:
        return "cloud.rain.fill"
    case 51.0, 52.0, 53.0:
        return "cloud.snow.fill"
    default:
        print("unknown value: \(value)")
        return "questionmark.circle"
    }
}
