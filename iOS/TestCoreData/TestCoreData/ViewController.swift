//
//  ViewController.swift
//  TestCoreData
//
//  Created by Ning Li on 2019/7/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private lazy var manageContext = CoreDataStack().storeContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    @IBAction private func add() {
        let newVersion = NSEntityDescription.insertNewObject(forEntityName: "HTMLVersion", into: manageContext) as! HTMLVersion
        newVersion.url = "www.qq.com"
        newVersion.version = 1
        newVersion.time = NSDate()
        
        do {
            try manageContext.save()
            print("success")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func update() {
        let entity = NSEntityDescription.entity(forEntityName: "HTMLVersion", in: manageContext)
        let request = NSFetchRequest<HTMLVersion>(entityName: "HTMLVersion")
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        let predicate = NSPredicate(format: "url='www.qq.com'")
        request.predicate = predicate
        
        do {
            let result = try manageContext.fetch(request)
            if let versionInfo = result.first {
                versionInfo.version += 1
                versionInfo.time = NSDate()
                try manageContext.save()
                let result = try manageContext.fetch(request)
                result.forEach { print($0.url!, $0.version, $0.time!.description(with: Locale(identifier: "zh_CN"))) }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func query() {
        let entity = NSEntityDescription.entity(forEntityName: "HTMLVersion", in: manageContext)
        let request = NSFetchRequest<HTMLVersion>(entityName: "HTMLVersion")
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        let predicate = NSPredicate(format: "url='www.baidu.com'")
        request.predicate = predicate
        
        do {
            let result = try manageContext.fetch(request)
            result.forEach { print($0.url!, $0.version) }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

