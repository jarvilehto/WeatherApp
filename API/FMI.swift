//
//  FMI.swift
//  TestEnvironment
//
//  Created by Teemu on 10.12.2022.
//

import Foundation

class FMI: ObservableObject {
    private let baseUrl = "https://opendata.fmi.fi/wfs"
    
     @Published var loc: String = "Espoo"
     @Published var data: [String: [WeatherStatus]] = [:]
     
    
    init() {
        getForecast(place: "Espoo")
    }
    
    func getForecast(place: String) {
        var url = URL(string: baseUrl)
        
        let parametersString = Identifier.allCases.map({$0.rawValue}).joined(separator: ",")
        
        url?.append(queryItems: [
            URLQueryItem(name: "request", value: "getFeature"),
            URLQueryItem(name: "storedquery_id", value: "fmi::forecast::harmonie::surface::point::timevaluepair"),
            URLQueryItem(name: "place", value: place),
            URLQueryItem(name: "parameters", value: parametersString)
        ])
        
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("dataTaskWithRequest error: \(error)")
                return
            }
            
            guard let data = data else {
                print("dataTaskWithRequest data is nil")
                return
            }
            
            let parser = XMLParser(data: data)
            let fmiParser = FMIParser()
            parser.delegate = fmiParser
            parser.parse()
            
            DispatchQueue.main.async {
                self.data[place] = fmiParser.data
                self.loc = place
            }
        }
        task.resume()
    }
    
}
