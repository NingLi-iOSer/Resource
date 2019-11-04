//
//  CoreDataStack.swift
//  TestCoreData
//
//  Created by Ning Li on 2019/7/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import CoreData

struct CoreDataStack {
    
    let storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HTMLVersion")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        })
        return container
    }()
    
    func saveContext() {
        guard storeContainer.viewContext.hasChanges else { return }
        
        do {
            try storeContainer.viewContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
}
