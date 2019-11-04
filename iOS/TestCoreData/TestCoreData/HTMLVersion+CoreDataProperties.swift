//
//  HTMLVersion+CoreDataProperties.swift
//  TestCoreData
//
//  Created by Ning Li on 2019/7/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//
//

import Foundation
import CoreData


extension HTMLVersion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HTMLVersion> {
        return NSFetchRequest<HTMLVersion>(entityName: "HTMLVersion")
    }

    @NSManaged public var url: String?
    @NSManaged public var version: Int16
    @NSManaged public var time: NSDate?

}
