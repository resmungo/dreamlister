//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Allan Edwards on 5/8/17.
//  Copyright © 2017 Allan Edwards. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
