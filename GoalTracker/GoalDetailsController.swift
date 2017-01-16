//
//  GoalDetailsController.swift
//  GoalTracker
//
//  Created by Dan Wiegand on 1/16/17.
//  Copyright © 2017 StopIt. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GoalDetailsController: UIViewController {
    
    
    @IBOutlet weak var goalNameLabel: UILabel!
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var createdByLabel: UILabel!
    
    var dashboardController: DashboardController?
    
    var refHandle: UInt?
    var goals = [Goal]()
    var goal: Goal? {
        didSet {
          goalNameLabel.text = goal?.goalName  
        }
    }
    var passedValue: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchGoals()
        fetchUsers()
        
        goalNameLabel.text = passedValue?.goalName
        goalDescriptionLabel.text = passedValue?.goalDescription
        createdAtLabel.text = passedValue?.created_at

        
        
    }
    
    func fetchUsers() {
        
            if FIRAuth.auth()?.currentUser != nil {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com").child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let name = dictionary["name"]
                    print(name!)
                    if name == nil {
                        self.createdByLabel.text = "User Has No Name, Uh Oh!"
                    }
                    self.createdByLabel.text = name as! String?
                }
            })
        }

        
    }
    
    
    func fetchGoals() {
        
        
        let ref = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com")
        
        
        refHandle = ref.child("goals").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let goal = Goal()
                goal.setValuesForKeys(dictionary)
                self.goals.append(goal)
                
//                print(dictionary)
    
            }
        })
    }
    
    
    
    
    
    
    
}
