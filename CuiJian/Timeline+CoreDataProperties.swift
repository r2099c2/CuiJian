//
//  Timeline+CoreDataProperties.swift
//  CuiJian
//
//  Created by Rick on 16/1/26.
//  Copyright © 2016年 Rick. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Timeline {

    @NSManaged var ID: NSNumber?
    @NSManaged var post_date: NSDate?
    @NSManaged var post_modified: NSDate?
    @NSManaged var post_title: String?
    @NSManaged var post_content: String?
    @NSManaged var feature_image: String?

}
