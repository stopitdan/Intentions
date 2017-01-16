//
//  TabBarController.swift
//  IntentionTracker
//
//  Created by Dan Wiegand on 1/9/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import TransitionAnimation
import TransitionTreasury


class ProfileController: UIViewController, NavgationTransitionable{
    
    @IBOutlet weak var downSwipeView: UIView!
    
    @IBAction func hideTabBarPressed(_ sender: UIButton) {
        setTabBarVisible(visible: false, animated: true)
//        self.tabBarItem.accessibilityElementsHidden = true
//        self.tabBarController?.tabBar.isHidden = true
    }
    


    weak var modalDelegate: ModalViewControllerDelegate?
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.screenEdgeSwiped))
        edgePan.edges = .bottom
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(edgePan)
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



extension UIViewController {
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        // hide tab bar
        let frame = self.tabBarController?.tabBar.frame
        
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        print("offsetY = \(offsetY)")
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        // animate tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                self.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height + offsetY!)
                
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                return
            }
        }
        
    }
    
    func tabBarIsVisible() -> Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < UIScreen.main.bounds.height
    }
    
}



// STRENGTHS

//curious
//determined
//authentic
//entertaining
//intelligent

// WEAKNESSES

//organized
//willpower
//disciplined
//communicative
//motivated
