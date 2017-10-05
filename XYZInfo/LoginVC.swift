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
		

		
		if(username.text!.characters.count > 4){
			if(password.text!.characters.count > 4){

				Data.shared.clientID = username.text!
				Data.shared.clientPass = password.text!
				Data.shared.verificationStatus = false
				
				if(senderLogic.shared.isConnected() == false){
					senderLogic.shared.connect()
				}
				senderLogic.shared.verificationRequest()
				
				if(senderLogic.shared.isConnected() == true){
					var timeout = 0
				
					while(timeout<=30){
						if(Data.shared.transferStatus == true){
							performSegue(withIdentifier: "Change", sender: nil)
						}
						timeout = timeout+1
						sleep(1)
					}
				}else{
					print("Not connected")
				}
				
			}
		}

	}
	
	
}

