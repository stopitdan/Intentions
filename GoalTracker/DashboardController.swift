//
//  DashboardController.swift
//  IntentionTracker
//
//  Created by Alex Villacres on 1/12/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class DashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var goals = [Goal]()
    var userList = [User]()
    var refHandle: UInt!
    
    @IBOutlet weak var subTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchGoals()
        
        
        
        print(goals)
        // Do any additional setup after loading the view.
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.screenEdgeSwiped))
        edgePan.edges = .bottom
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(edgePan)
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
            print("Screen edge swiped!")
        }
    }
    
   
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
        try FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "Logout", sender: self)
        }catch{
            print("Error")
        }
    }
    
    func fetchGoals() {
        var ref: FIRDatabaseReference = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com")

        refHandle = ref.child("goals").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                print(dictionary)
                
                let goal = Goal()
                goal.setValuesForKeys(dictionary)
                self.goals.append(goal)
                DispatchQueue.main.async {
                    self.subTableView.reloadData()
                }
                
            }
        })
    }
    
    func fetchGoal() {
        
        
        
        
        
        
        
//        if FIRAuth.auth()?.currentUser != nil {
//            let ref = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com")
//                ref.child("goals").observe(.value, with: { (snapshot) in
//                for child in snapshot.children {
//                    print(child)
//                }
//                
//            }, withCancel: nil)
            //            let uid = FIRAuth.auth()?.currentUser?.uid
            //            FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com").child("users").child(uid!).observe(.childAdded, with:
            //                { (snapshot) in
            //                    if let dictionary = snapshot.value as? [String: AnyObject] {
            //
            //                        let goal = Goal()
            //                        goal.setValuesForKeys(dictionary)
            //                        self.goals.append(goal)
            //                        print(self.goals)
            //                        print(dictionary)
            //
            //                    }
            //                    
            //            }
            //                    , withCancel: nil)
            //            }
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        cell.textLabel?.text = goals[indexPath.row].goalName
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
//        let goal = goals[indexPath.row]
//        for goal in goals {
//        cell.textLabel?.text = goal.goalName
//        }
//        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

}
