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
				Data.shared.verificationStatus = 0
				
				senderLogic.shared.configure()
				
				if(senderLogic.shared.isConnected() == false){
					print("not Connected")
					senderLogic.shared.connect()
				}
				var timeout = 0
				while(timeout<=60){
					if(senderLogic.shared.mqtt.connState.rawValue == 2){
						break
					}
					
					timeout = timeout+1
					sleep(1)
					print ("waiting ", +timeout)
				}
				if(senderLogic.shared.isConnected() == true){
				
					timeout = 0
					if(senderLogic.shared.isConnected() == false){
						print("not connected, attempt to re connect")
						senderLogic.shared.connect()
					}
					while(timeout<=30){
						if(senderLogic.shared.isConnected() == false){
							print("not connected, attempt to re connect")
							senderLogic.shared.connect()
						}
						if(Data.shared.notReady){

						}else{
							senderLogic.shared.verificationRequest()
							
							if(Data.shared.transferStatus == 1 ){
								performSegue(withIdentifier: "Change", sender: nil)
							}
							if(Data.shared.transferStatus == 2 ){
								print("Failed")
								senderLogic.shared.mqtt.disconnect()
							}
						}
						timeout = timeout+1
						sleep(1)
					}
					
					if (timeout >= 30){
						print("Timeout, please try again later")
						senderLogic.shared.mqtt.disconnect()
						
					}
					
				}else{
					print("Not connected")
					senderLogic.shared.mqtt.disconnect()
				}
				
				
				
			}
		}

	}
	
	
}

