//
//  ToDoDetailViewController.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoDetailViewController: UIViewController  {
    
    // MARK: - Outlets
    @IBOutlet weak var toDoNameField: UITextField!
    @IBOutlet weak var toDoDatePicker: UIDatePicker!
    @IBOutlet weak var toDoCompleteSwitch: UISwitch!
    @IBOutlet weak var toDoModifiedLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categorySet: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    var categoryArray = ["Work", "Home", "Other"]
    var categoryPick = 0
    var selectedPick: String {
        return UserDefaults.standard.string(forKey: "categoryPick") ?? ""
    }
    
    
    var todo = ToDo()
    var todocell = ToDoTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categorySet.delegate = self
        categorySet.dataSource = self
        if let row = categoryArray.index(of: selectedPick) {
            categorySet.selectRow(row, inComponent: 0, animated: false)
        }
        toDoNameField.text = todo.title
        toDoModifiedLabel.text = todo.dateString
        selectedDate.text = todo.dueDate
        categoryLabel.text = todo.categoryLabel
        toDoCompleteSwitch.isOn = todo.completed
        
        if let image = todo.image {
            imageView.image = image
            addGestureRecognizer()
        } else {
            imageView.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewImage() {
        if let image = imageView.image {
            ToDoStore.shared.selectedImage = image
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
            present(viewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        todo.title = toDoNameField.text!
        todo.date = Date()
        toDoModifiedLabel.text = todo.dateString
        todo.categorySet = categorySet.selectedRow(inComponent: 0)
        todo.dueDate = selectedDate.text!
        todo.image = imageView.image
        todo.categoryLabel = categoryLabel.text!
        
        let notify = UNMutableNotificationContent()
        notify.title = NSString.localizedUserNotificationString(forKey: "ToDoListSKC", arguments: nil)
        notify.body = NSString.localizedUserNotificationString(forKey: todo.title, arguments: nil)
        notify.sound = UNNotificationSound.default()
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .day], from: toDoDatePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest.init(identifier: todo.id, content: notify, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [todo.id])
        center.add(request)
        
        ToDoStore.shared.sort()
        ToDoStore.shared.save()
    }

    // MARK: - IBActions
    
    
    @IBAction func completedClicked(sender: UISwitch) {
        if toDoCompleteSwitch.isOn {
            toDoCompleteSwitch.setOn(false, animated:true)
            todo.completed = false
            todo.completeLabel = ""
        } else {
            toDoCompleteSwitch.setOn(true, animated:true)
            todo.completed = true
            todo.completeLabel = "Complete"
        }
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let strDate = dateFormatter.string(from: toDoDatePicker.date)
        selectedDate.text = strDate
        
    }
    
    @IBAction func choosePhoto(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Picture", message: "Choose a picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func savePickerItem(_ sender: AnyObject) {
        if sender.tag == 0 {
            todo.categorySet = 0
        } else if sender.tag == 1 {
            todo.categorySet = 1
        } else if sender.tag == 2 {
            todo.categorySet = 2
        }
    }
    
    
}

extension ToDoDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            let maxSize: CGFloat = 512
            let scale = maxSize / image.size.width
            let newHeight = image.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView.image = resizedImage
            
            imageView.isHidden = false
            if gestureRecognizer != nil {
                imageView.removeGestureRecognizer(gestureRecognizer)
            }
            addGestureRecognizer()
            
        }
    }
    
    
}

extension ToDoDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(categoryArray[row], forKey: "categoryPick")
        
        categoryPick = row
        
        if (categoryPick == 0) {
            categoryLabel.text = "Work"
        } else if (categoryPick == 1) {
            categoryLabel.text = "Home"
        } else if (categoryPick == 2) {
            categoryLabel.text = "Other"
        }
    }
}
