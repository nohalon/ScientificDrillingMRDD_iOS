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
    let log = Logging()
    
    @IBOutlet weak var btnGPlus: GPPSignInButton!
    @IBOutlet weak var label: UILabel!
    
    var signIn: GPPSignIn?
    
    var loginSuccessful = false;
    let config = PropertyManager.loadPropertiesFromFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load configuration data for app
        //config.loadPropertiesFromFile()
        
        // Configure Google Login
        signIn = GPPSignIn.sharedInstance()
        
        btnGPlus.style = kGPPSignInButtonStyleWide
        btnGPlus.colorScheme = kGPPSignInButtonColorSchemeDark
        
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = config["googleClientID"] as! String
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
        wellsMngr.wells = []
    }

    //Go to home page if authenticated
    func checkSignIn() {
        if GPPSignIn.sharedInstance().authentication != nil {
            // Load Wells
            wellsMngr.loadWells()
            performSegueWithIdentifier("WellsSegue", sender: self)
        }
    }

    //After authentication
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        checkSignIn()
    }
    
    @IBAction func unwindToLogin2(segue : UIStoryboardSegue) {
        if segue.identifier == "LogoutSegue2" {

            if loginSuccessful {
                wellsMngr.loadWells()
                self.dismissViewControllerAnimated(true, completion: {
                    self.performSegueWithIdentifier("WellsSegue", sender: self)
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WellsSegue" {
            println("prepareForSegue: WellsSegue")
        }
    }
    
    @IBAction func unwindToLogin(segue : UIStoryboardSegue) {
        if segue.identifier == "LogoutSegue" {
            logoutApplication()
        }
    }
}

