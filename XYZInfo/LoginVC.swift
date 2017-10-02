//
//  ViewController.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class LoginVC: UIViewController {
	@IBOutlet weak var Username: UITextField!
	@IBOutlet weak var Password: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func Logon(_ sender: Any) {
		let username = Username.text
		let password = Password.text

		
		if(!(username?.isEmpty)!){
			if(!(password?.isEmpty)!){
				SwiftyPlistManager.shared.addNew("Username", key: username!, toPlistWithName: "Data") {(err) in
					if err == nil {
						print("Value successfully saved into plist.")
					}
				}
				SwiftyPlistManager.shared.save("Username", forKey: username!, toPlistWithName: "Data") {(err) in
					if err == nil {
						print("Value successfully saved into plist.")
					}
				}
				
				SwiftyPlistManager.shared.addNew("Password", key: password!, toPlistWithName: "Data") {(err) in
					if err == nil {
						print("Value successfully saved into plist.")
					}
				}
				SwiftyPlistManager.shared.save("Password", forKey: password!, toPlistWithName: "Data") {(err) in
					if err == nil {
						print("Value successfully saved into plist.")
					}
				}
			}
		}
		
	}
	
	
}

