//
//  LoginViewController.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 3/6/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loginuiview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        let gsb = GIDSignInButton()
        self.loginuiview.addSubview(gsb)
    }
}
