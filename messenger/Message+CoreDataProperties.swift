//
//  Message+CoreDataProperties.swift
//  messenger
//
//  Created by Manav Trivedi on 10/10/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var data: String?
    @NSManaged public var inAssets: Bool
    @NSManaged public var read: Bool
    @NSManaged public var sender: Bool
    @NSManaged public var time: Date?
    @NSManaged public var type: String?
    @NSManaged public var friend: Friend?

}
