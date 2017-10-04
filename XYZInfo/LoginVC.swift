//
//  ViewController.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import SwiftyPlistManager


class LoginVC: UIViewController{

	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func Logon(_ sender: Any) {
		
		print(username.text!)
		print(password.text!)
		
		if(username.text!.characters.count > 4){
			if(password.text!.characters.count > 4){
				let data = Data.shared

				print(username.text!)
				print(password.text!)
				
				data.clientID = username.text!
				data.clientPass = password.text!
				data.verificationStatus = false
				
				print("Username: " + data.clientID + " | Password: " + data.clientPass)
				
				print(username.text!)
				print(password.text!)
				
				performSegue(withIdentifier: "Change", sender: "LoginVC")
				
				
				
			}
		}

	}
	
	
}

