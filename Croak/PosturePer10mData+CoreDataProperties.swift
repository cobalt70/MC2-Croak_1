//
//  PosturePer10mData+CoreDataProperties.swift
//  Croak
//
//  Created by jeong hyein on 5/16/24.
//
//

import Foundation
import CoreData


extension PosturePer10mData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PosturePer10mData> {
        return NSFetchRequest<PosturePer10mData>(entityName: "PosturePer10mData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: String?
    @NSManaged public var startTime: String?
    @NSManaged public var posture: String?
    @NSManaged public var tempDate: Date?

}

extension PosturePer10mData : Identifiable {

}
