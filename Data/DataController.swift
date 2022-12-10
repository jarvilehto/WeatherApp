//
//  DataController.swift
//  Weather
//
//  Created by Teemu on 6.12.2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FavouriteModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("Data was not saved")
        }
    }
    
    func addFavourite(place: String, context: NSManagedObjectContext) {
        let favourite = Favourite(context: context)
        favourite.id = UUID()
        favourite.place = place
        
        save(context: context)
    }
}
