//
//  ToDo.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import Foundation
import UIKit

class ToDo: NSObject, NSCoding {
    var title = ""
    var date = Date()
    var completed: Bool = false
    var image: UIImage?
    var dueDate = ""
    var categorySet: Int = 0
    var categoryLabel = ""
    var priority: Double = 0.0
    var toggleSwitch: Int = 0
    var completeLabel = ""
    var id = UUID.init().uuidString
    
    let titleKey = "title"
    let dateKey = "date"
    let categoryKey = "category"
    let completedKey = "completed"
    let imageKey = "image"
    let dueDateKey = "dueDate"
    let categorySetKey = "categorySet"
    let priorityKey = "priority"
    let categoryLabelKey = "categoryLabel"
    let idKey = "id"
    let completeLabelKey = "completeLabel"
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    override init() {
        super.init()
        
    }
    
    init(title: String, dueDate: String) {
        self.title = title
        self.dueDate = dueDate
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: titleKey) as! String
        self.dueDate = aDecoder.decodeObject(forKey: dueDateKey) as! String
        self.completed = aDecoder.decodeBool(forKey: completedKey)
        self.date = aDecoder.decodeObject(forKey: dateKey) as! Date
        self.image = aDecoder.decodeObject(forKey: imageKey) as? UIImage
        self.categorySet = aDecoder.decodeInteger(forKey: categorySetKey)
        self.priority = aDecoder.decodeDouble(forKey: priorityKey)
        self.categoryLabel = aDecoder.decodeObject(forKey: categoryLabelKey) as! String
        self.id = aDecoder.decodeObject(forKey: idKey) as! String
        self.completeLabel = aDecoder.decodeObject(forKey: completeLabelKey) as! String
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(date, forKey: dateKey)
        aCoder.encode(image, forKey: imageKey)
        aCoder.encode(dueDate, forKey: dueDateKey)
        aCoder.encode(completed, forKey: completedKey)
        aCoder.encode(categorySet, forKey: categorySetKey)
        aCoder.encode(priority, forKey: priorityKey)
        aCoder.encode(categoryLabel, forKey: categoryLabelKey)
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(completeLabel, forKey: completeLabelKey)
    }
}

