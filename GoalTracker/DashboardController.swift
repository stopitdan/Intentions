//
//  DashboardController.swift
//  IntentionTracker
//
//  Created by Alex Villacres on 1/12/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase

class DashboardController: UITableViewController, UINavigationControllerDelegate {
    
    var goals = [Goal]()
    var refHandle: UInt?
    var valueToPass:Goal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(28,0,0,0);
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
   
    @IBAction func logoutButtonPress(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "Logout", sender: nil)
        } catch {
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
//                    print(item.key)
                    if item.key == "userID" {
                        if item.value as! String == (FIRAuth.auth()?.currentUser?.uid)! {
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
        
            cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
    
            
            let goal = goals[(goals.count - 1 - indexPath.row)]
            if goal.userID == FIRAuth.auth()?.currentUser?.uid {
                cell.textLabel?.text = goal.goalName
            }
        
        return cell
 
    }
    
    var goalDetailsController: GoalDetailsController?
    
    func showGoalDetails(goal: Goal) {
        performSegue(withIdentifier: "AccesoryTapped", sender: self)
//        GoalDetailsController.goal = goal
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        
        
//        let goal = self.goals[indexPath.row]
//        print(self.goals[indexPath.row])
//        self.showGoalDetails(goal: goal)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = self.goals[(goals.count - 1 - indexPath.row)]
        performSegue(withIdentifier: "AccesoryTapped", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AccesoryTapped") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! GoalDetailsController
            // your new view controller should have property that will store passed value
            viewController.passedValue = valueToPass
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

}
