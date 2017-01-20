//
//  AddGoalController.swift
//  IntentionTracker
//
//  Created by Alex Villacres on 1/12/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class AddGoalController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if tabBarIsVisible() == true {
            setTabBarVisible(visible: false, animated: true)
        }
        else {
            print("Already hidden you fucking dipshit")
        }
    }
    
    func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            setTabBarVisible(visible: true, animated: true)
            print("Screen edge swiped, ya cunt!")
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goalTextField.delegate = self
        self.descriptionTextField.delegate = self
        
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.screenEdgeSwiped))
        edgePan.edges = .bottom
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(edgePan)
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
            let value = ["goalName": goalTextField.text!, "goalDescription": descriptionTextField.text!, "userID": user, "created_at": now]
            childRef.updateChildValues(value)
            print(goalTextField.text!)
            print(descriptionTextField.text!)
            
        }
    }
}
