//
//  ViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 17/09/14.

import UIKit
import BWWalkthrough

class WalkthroughController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "Master") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "page1")
        let page_two = stb.instantiateViewController(withIdentifier: "page2")
        let page_three = stb.instantiateViewController(withIdentifier: "page3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(vc: page_one)
        walkthrough.addViewController(vc: page_two)
        walkthrough.addViewController(vc: page_three)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

