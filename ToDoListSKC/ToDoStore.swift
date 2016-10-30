//
//  ToDoStore.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoStore {
    static let shared = ToDoStore()
    
    var todos: [[ToDo]]!
    
    var todo = ToDo()
    var tododetail = ToDoDetailViewController()
    
    var selectedImage: UIImage?
    
    init() {
        let filePath = archiveFilePath()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath) {
            todos = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [[ToDo]]
        } else {
            todos = [[], [], []]
            todos[0].append(ToDo(title: "Sell Fish", dueDate: "11-05-3892 12:00"))
            todos[1].append(ToDo(title: "Feed Fish", dueDate: "Every Day!!!"))
            todos[2].append(ToDo(title: "Talk about Fish", dueDate: "Now o'clock" ))
            save()
        }
        sort()
    }
    
    
    // MARK: - Public functions
    func getToDo(_ index: Int, categorySet: Int) -> ToDo {
        return todos[categorySet][index]
    }
    
    func addToDo(_ todo: ToDo, categorySet: Int) {
        todos[categorySet].insert(todo, at: 0)
        save()
    }
    
    func updateToDo(_ todo: ToDo, index: Int, categorySet: Int) {
        todos[categorySet][index] = todo
    }
    
    func deleteToDo(_ index: Int, categorySet: Int) {
        todos[categorySet].remove(at: index)
    }
    
    func getCount(categorySet: Int) -> Int {
        return todos[categorySet].count
    }
        
    func getCategoryCount() -> Int {
            return tododetail.categoryArray.count
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(todos, toFile: archiveFilePath())
    }
    
    func sort() {
        for i in 0..<todos.count {
            todos[i].sort(by: { (toDo1, toDo2) -> Bool in
                return toDo1.priority < toDo2.priority
        })
    }
    }
    
    
    // MARK: - Private Functions
    fileprivate func archiveFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDirectory = paths.first!
        let path = (documentsDirectory as NSString).appendingPathComponent("NoteStore.plist")
        return path
    }
}
