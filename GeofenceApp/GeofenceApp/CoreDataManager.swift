//
//  CoreDataManager.swift
//  GeofenceApp
//
//  Created by Carlos Alcala on 9/6/21.
//

import CoreData
import Foundation

class CoreDataManager {
    private let container: NSPersistentContainer!

    init() {
        container = NSPersistentContainer(name: "GeofenceApp")

        setupDatabase()
    }

    private func setupDatabase() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }

    func userHasEnter(name : String, latitude : Double, longitude : Double, hasEnter : Bool, completion: @escaping() -> Void) {
        
        let context = container.viewContext

        let user = User(context: context)
        user.name = name
        user.latitude = latitude
        user.longitude = longitude
        user.hasEnter = true

        do {
            try context.save()
            print("User \(name) enter")
            completion()
        } catch {
            print("Error — \(error)")
        }
    }
}
