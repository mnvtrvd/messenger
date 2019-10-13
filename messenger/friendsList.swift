//
//  friendsList.swift
//  messenger
//
//  Created by Manav Trivedi on 10/6/19.
//  Copyright © 2019 E<Z<>. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension friendsVC {
    func newFriend(name: String, imgName: String, context: NSManagedObjectContext) -> Friend {
        let friend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        friend.name = name
        friend.profImg = imgName
        return friend
    }
    
    static func newMsg(friend: Friend, data: String, read: Bool = true, minutesAgo: Double = 0, sender: Bool = true, type: String = "MSG", inAssets: Bool = true, context: NSManagedObjectContext) -> Message {
        let msgData = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        msgData.data = data
        msgData.type = type
        msgData.time = NSDate().addingTimeInterval(-minutesAgo*60) as Date
        msgData.read = read
        msgData.friend = friend
        msgData.sender = sender
        msgData.inAssets = inAssets
        return msgData
    }
    
    func setData() {
//        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            if entityEmpty(context: context, entity: "Friend") {
                clearData()
                initData(context: context)
            }
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    func entityEmpty(context: NSManagedObjectContext, entity: String) -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let count  = try context.count(for: request)
            return count == 0 ? true : false
        } catch{
            return true
        }
        
    }
    
    func initData(context: NSManagedObjectContext) {
        let carnegie = newFriend(name: "Andrew Carnegie", imgName: "carnegie", context: context)
        _ = friendsVC.newMsg(friend: carnegie, data: "My heart is in the work!", minutesAgo: 3*390*day+2, context: context)
        _ = friendsVC.newMsg(friend: carnegie, data: "The steel industry will prevail!", minutesAgo: 2*390*day+1, context: context)
        _ = friendsVC.newMsg(friend: carnegie, data: "You should attend CMU!", read: false, minutesAgo: 2*390*day, context: context)
        
        let mellon = newFriend(name: "Andrew Mellon", imgName: "mellon", context: context)
        _ = friendsVC.newMsg(friend: mellon, data: "I am the less famous Andrew!", minutesAgo: 390*day, context: context)
        _ = friendsVC.newMsg(friend: mellon, data: "I was the US Secretary of Treasury!", minutesAgo: 381*day, context: context)
        _ = friendsVC.newMsg(friend: mellon, data: "You should attend CMU!", read: false, minutesAgo: 380*day, context: context)
        
        let subra = newFriend(name: "Subra Suresh", imgName: "subra", context: context)
        _ = friendsVC.newMsg(friend: subra, data: "I am the president of CMU", minutesAgo: 23*day, context: context)
        _ = friendsVC.newMsg(friend: subra, data: "jk", minutesAgo: 20*day, context: context)
        _ = friendsVC.newMsg(friend: subra, data: "I dipped to go to Singapore", minutesAgo: 15*day, context: context)
        _ = friendsVC.newMsg(friend: subra, data: "farnam", read: false, minutesAgo: 2*day, sender: false, type: "IMG", context: context)
        _ = friendsVC.newMsg(friend: subra, data: "This dude replaced you        ", minutesAgo: 2*day, sender: false, context: context)
        _ = friendsVC.newMsg(friend: subra, data: "😂", read: false, minutesAgo: 2*day, type: "EMOJI", context: context)
        
        let tepper = newFriend(name: "David Tepper", imgName: "tepper", context: context)
        _ = friendsVC.newMsg(friend: tepper, data: "I graduated from CMU just like you!", minutesAgo: 3*day, context: context)
        _ = friendsVC.newMsg(friend: tepper, data: "The Tepper Quad is named after me", read: false, minutesAgo: 2*day, context: context)
        _ = friendsVC.newMsg(friend: tepper, data: "tepper-quad", read: false, minutesAgo: 2*day, type: "IMG", context: context)
        
        let farnam = newFriend(name: "Farnam Jahanian", imgName: "farnam", context: context)
        _ = friendsVC.newMsg(friend: farnam, data: "Nice to meet you I am the new president of CMU. I have been a provost in the past and I look forward to getting to know you over the next coming few years", minutesAgo: 5, context: context)
        _ = friendsVC.newMsg(friend: farnam, data: "I look forward to getting to know you!", minutesAgo: 5, sender: false, context: context)
        _ = friendsVC.newMsg(friend: farnam, data: "like", read: false, minutesAgo: 3, type: "LIKE", context: context)
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            if let friends = getFriends() {
                msgs = [Message]()
                for friend in friends {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetch.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
                    fetch.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetch.fetchLimit = 1

                    do {
                        let newMsg = try context.fetch(fetch) as? [Message]
                        msgs?.append(contentsOf: newMsg!)
                    } catch let err {
                        print(err)
                    }
                }
                msgs = msgs?.sorted(by: {$0.time!.compare($1.time! as Date) == .orderedDescending})
            }
        }
    }
    
//    func simulate(friend: Friend, context: NSManagedObjectContext) {
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        if let context = delegate?.persistentContainer.viewContext {
//            _ = friendsVC.newMsg(friend: friend, data: "This is a simulated message", minutesAgo: 0, context: context)
//            do {
//                try context.save()
//            } catch let err {
//                print(err)
//            }
//        }
//    }
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let entities = ["Friend", "Message"]
                for entity in entities {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    let objs = try(context.fetch(fetch)) as? [NSManagedObject]
                    for obj in objs! { context.delete(obj) }
                }
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    
    func getFriends() ->[Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                return try context.fetch(request) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
}
