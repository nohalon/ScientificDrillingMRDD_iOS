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
        
        // Configure Google Login
        signIn = GPPSignIn.sharedInstance()
        
        btnGPlus.style = kGPPSignInButtonStyleWide
        btnGPlus.colorScheme = kGPPSignInButtonColorSchemeDark
        
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "741302004274-03334h3tk30brn2n9fhe9l32nnn6gk1k.apps.googleusercontent.com"
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
            performSegueWithIdentifier("WellsSegue", sender: "LoginViewController")
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
    }
}

