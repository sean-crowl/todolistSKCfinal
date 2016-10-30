//
//  ToDoTableViewCell.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoDateLabel: UILabel!
    @IBOutlet weak var completeLabelView: UILabel!

    weak var todo: ToDo!
    weak var todocell: ToDoTableViewCell!
    
    var isComplete: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell(todo: ToDo) {
        self.todo = todo
        toDoTitleLabel.text! = todo.title
        toDoDateLabel.text! = todo.dueDate
        isComplete = todo.completed
        completeLabelView.text! = todo.completeLabel
    }
    
}
