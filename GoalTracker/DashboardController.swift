//
//  DashboardController.swift
//  IntentionTracker
//
//  Created by Alex Villacres on 1/12/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class DashboardController: UITableViewController {
    
    
    @IBOutlet weak var swipeView: UIView!
    
    let currUser = FIRAuth.auth()?.currentUser?.uid
    var goals = [Goal]()
    var refHandle: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        fetchGoals()

        print(goals)
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        
        let swipeUp = UISwipeGestureRecognizer(target: swipeView, action: #selector(respondToSwipeGestureForAdd))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.screenEdgeSwiped))
        edgePan.edges = .bottom
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(edgePan)
    }
    
    func respondToSwipeGestureForAdd(gesture: UIGestureRecognizer) {
            print("You got me")
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
        
        
        let ref = FIRDatabase.database().reference(fromURL: "https://intentiontracker-cfbda.firebaseio.com")
        
        
        refHandle = ref.child("goals").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                //                print(dictionary)
                
                let goal = Goal()
                
                
                goal.setValuesForKeys(dictionary)
                for item in dictionary {
                    print(item.key)
                    if item.key == "userID" {
                        if item.value as! String == self.currUser! {
                            self.goals.append(goal)
                        }
                        
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
                
            }
        })
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        tableView.separatorInset = UIEdgeInsetsMake( 0, 0, 0, 0)
//        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        let goal = goals[(goals.count - 1 - indexPath.row)]
        if goal.userID == currUser {
            cell.textLabel?.text = goal.goalName
        }
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
//        let goal = goals[indexPath.row]
//        for goal in goals {
//        cell.textLabel?.text = goal.goalName
//        }
//        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

}
