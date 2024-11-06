//
//  PosturePer10m+CoreDataProperties.swift
//  Croak
//
//  Created by jeong hyein on 5/16/24.
//
//

import Foundation
import CoreData


extension PosturePer10m {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PosturePer10m> {
        return NSFetchRequest<PosturePer10m>(entityName: "PosturePer10m")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: String?
    @NSManaged public var startTime: String?
    @NSManaged public var posture: String?
    @NSManaged public var tempDate: Date?

}

extension PosturePer10m : Identifiable {

}
