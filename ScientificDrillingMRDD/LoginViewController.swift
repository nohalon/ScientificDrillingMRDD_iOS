//
//  LoginViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class LoginViewController: UIViewController, GPPSignInDelegate {
    
    @IBOutlet weak var btnGPlus: GPPSignInButton!
    @IBOutlet weak var label: UILabel!
    
    var signIn: GPPSignIn?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load configuration data for app
        config.loadPropertiesFromFile()
        
        // Configure Google Login
        signIn = GPPSignIn.sharedInstance()
        
        btnGPlus.style = kGPPSignInButtonStyleWide
        btnGPlus.colorScheme = kGPPSignInButtonColorSchemeDark
        
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = config.getProperty("googleClientID") as String
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.delegate = self
        
        signIn?.trySilentAuthentication()
        //signIn?.authenticate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //Pop views back to login
    func logoutApplication() {
        signIn?.signOut()
        navigationController?.popToRootViewControllerAnimated(true)
        println("Logging out")
    }

    //Go to home page if authenticated
    func checkSignIn() {
        if GPPSignIn.sharedInstance().authentication != nil {
            // Load Wells
            wellsMngr.loadWells()
            performSegueWithIdentifier("WellsSegue", sender: self)
        } else {
            println("Not logged in")
        }
    }

    //After authentication
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        checkSignIn()
        //println(auth)
    }
    
    func didDisconnectWithError(error: NSError!) {
        println()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WellsSegue"
        {
            if let destinationVC = segue.destinationViewController as? WellsViewController {
                println("Segue")
            }
        }
        else if segue.identifier == "LogoutSegue"
        {
            
        }
    }
    
    @IBAction func unwindToLogin(segue : UIStoryboardSegue) {
        if segue.identifier == "LogoutSegue" {
            logoutApplication()
        }
    }
}

