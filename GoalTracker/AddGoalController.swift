//
//  AddGoalController.swift
//  IntentionTracker
//
//  Created by Alex Villacres on 1/12/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class AddGoalController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func SubmitButtonPressed(_ sender: UIButton) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.short
            dateformatter.timeStyle = DateFormatter.Style.short
            let now = dateformatter.string(from: NSDate() as Date)
            
            let user = FIRAuth.auth()?.currentUser?.uid
            let ref = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com").child("goals")
            let childRef = ref.childByAutoId()
            let value = ["goalName": goalTextField.text!, "description": descriptionTextField.text!, "userID": user, "created_at": now]
            childRef.updateChildValues(value)
            print(goalTextField.text!)
            print(descriptionTextField.text!)
        
        }
    }
}
