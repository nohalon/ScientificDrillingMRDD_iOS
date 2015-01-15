//
//  ViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 1/14/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ViewController: UIViewController, GPPSignInDelegate {

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

    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        println(auth)
    }
    
    func didDisconnectWithError(error: NSError!) {
        println()
    }
}

