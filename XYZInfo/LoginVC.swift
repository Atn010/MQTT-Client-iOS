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
				
				connectionLogic.shared.configure()
				connectionLogic.shared.mqtt.connect()
				if(connectionLogic.shared.mqtt.connState.rawValue == 0 || connectionLogic.shared.mqtt.connState.rawValue == 3){
					print("not Connected")
					connectionLogic.shared.connect()
				}
				
				print("MQTT ClientID : " + connectionLogic.shared.mqtt.clientID )
				print("MQTT BrokerURL: " + connectionLogic.shared.mqtt.host )
				print("MQTT Port     : " + connectionLogic.shared.mqtt.port.description)
				
				
				var timeout = 0
				while(timeout<=60){
					if(connectionLogic.shared.mqtt.connState.rawValue == 2){
						break
					}
					
					if(connectionLogic.shared.mqtt.connState.rawValue == 3){
						print("Failed to connect")
						break
					}
					if(connectionLogic.shared.mqtt.connState.rawValue == 1){
						timeout = timeout+1
						sleep(1)
						print ("waiting ", +timeout)
					}else{
						print("Unexpected Error Occured")
						break
					}
				}
				
				if(connectionLogic.shared.mqtt.connState.rawValue == 2){
				
					timeout = 0
					if(connectionLogic.shared.isConnected() == false){
						print("not connected, attempt to re connect")
						connectionLogic.shared.connect()
					}
					while(timeout<=30){
						if(connectionLogic.shared.isConnected() == false){
							print("not connected, attempt to re connect")
							connectionLogic.shared.connect()
						}
						if(Data.shared.notReady){

						}else{
							connectionLogic.shared.verificationRequest()
							
							if(Data.shared.transferStatus == 1 ){
								performSegue(withIdentifier: "Change", sender: nil)
							}
							if(Data.shared.transferStatus == 2 ){
								print("Failed")
								connectionLogic.shared.mqtt.disconnect()
							}
						}
						timeout = timeout+1
						sleep(1)
					}
					
					if (timeout >= 30){
						print("Timeout, please try again later")
						connectionLogic.shared.mqtt.disconnect()
						
					}
					
				}else{
					print("Not connected")
					connectionLogic.shared.mqtt.disconnect()
				}
				
				
				
			}
		}

	}
	
	
}

