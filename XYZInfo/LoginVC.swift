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
	
	let data = Data.shared
	let conLogic = connectionLogic.shared

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
				
				if(data.verificationStatus == 1){
					performSegue(withIdentifier: "Change", sender: nil)
				}else{
				

				Data.shared.clientID = username.text!
				Data.shared.clientPass = password.text!
				Data.shared.verificationStatus = 0
				
				conLogic.configure()
				//conLogic.mqtt.connect()
				conLogic.connect()
				
				print("MQTT ClientID : " + conLogic.mqtt.clientID )
				print("MQTT BrokerURL: " + conLogic.mqtt.host )
				print("MQTT Port     : " + conLogic.mqtt.port.description)
				}
			}
		}

	}
	
	
}

