//
//  AppDelegate.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {

    var window: UIWindow?
    var localNotification: UILocalNotification?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        //Configure Google Sign in
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        let types: UIUserNotificationType = UIUserNotificationType([.Alert, .Badge, .Sound])
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool
    {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        /*
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("before Email: " + user.profile.email)
            
        }
        //GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
        if let user = FIRAuth.auth()?.currentUser {
            print("before user id: \(user.uid)")
        }
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("after Email: " + user.profile.email)
        }
        //try! FIRAuth.auth()!.signOut()
        if let user = FIRAuth.auth()?.currentUser {
            print("after user id: \(user.uid)")
        }
        */
        if let uitabbarvc = window?.rootViewController as? UITabBarController {
            let vc: FirstViewController = (uitabbarvc.viewControllers![0] as? FirstViewController)!
            vc.allowNotifying = true
         }

        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("Email: " + user.profile.email)
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        if (self.localNotification != nil){
            let vc: FirstViewController = ((window?.rootViewController as! UITabBarController).viewControllers![0] as? FirstViewController)!
            vc.showMsg(self.localNotification!)
            vc.allowNotifying = false
            self.localNotification = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print ("applicationWillTerminate")
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("before Email: " + user.profile.email)
            
        }
        
        GIDSignIn.sharedInstance().disconnect()
        if let user = FIRAuth.auth()?.currentUser {
            print("before user id: \(user.uid)")
        }
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("after Email: " + user.profile.email)
        }
       //try! FIRAuth.auth()!.signOut()
        if let user = FIRAuth.auth()?.currentUser {
            print("after user id: \(user.uid)")
        }

    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        self.localNotification = notification
    }

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let user = GIDSignIn.sharedInstance().currentUser {
            print ("Email: " + user.profile.email)
        }
        if let user = FIRAuth.auth()?.currentUser {
            print("user id: \(user.uid)")
        }
        if let error = error {
            print (error.localizedDescription)
            return
        } /* else {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
        }
        */
        var authentication = user.authentication
        var credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)

        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print (error.localizedDescription)
                return
            }
            if let user = FIRAuth.auth()?.currentUser {
                print("user id: \(user.uid)")
            }

            let storyBoard: UIStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
            let tabBarController: UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = tabBarController
        }

    }
    

    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print (error.localizedDescription)
            return
        }
        print ("didDisconnectWithUser")
        let storyBoard: UIStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let vc: LoginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = vc
        try! FIRAuth.auth()!.signOut()

        // Perform any operations when the user disconnects from app here.
        // ...
    }

}

