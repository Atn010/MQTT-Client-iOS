//
//  senderLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT
import SwiftyPlistManager

class senderLogic: NSObject {
	
	let clientID: String = Data.init().clientID
	
	let topicVerificationRequest: String = "verification\request\\" + Data.init().clientID
	let topicVerificationResponse: String = "verification\response\\" + Data.init().clientID
	
	let topicTransactionRequest: String = "transaction\request\\" + Data.init().clientID
	let topicTransactionResponse: String = "transaction\response\\" + Data.init().clientID
	
	let topicTransferRequest: String = "transfer\request\\" + Data.init().clientID
	let topicTransferResponse: String = "transfer\response\\" + Data.init().clientID
	
	let Qos = CocoaMQTTQOS(rawValue: 1)
	
	
	func connect() {
		let mqtt = CocoaMQTT(clientID: clientID, host: "192.168.56.101", port: 1883)
		mqtt.autoReconnect = true
		mqtt.autoReconnectTimeInterval = 3
		mqtt.cleanSession = false
		mqtt.allowUntrustCACertificate = true
		mqtt.keepAlive = 60
		mqtt.delegate = self as? CocoaMQTTDelegate
		mqtt.connect()
		
	}
	
	func verificationRequest(){
		//let Date = DateFormatter().short
		//let Time = TimeFormatter().short
		
		//configure the message into: day/month/year hour:minute~username~password
		//EX: 31/12/17 03:02~admin~admin
		
		
		let message = CocoaMQTTMessage(topic: topicVerificationRequest, string: "request", qos: Qos!, retained: false, dup: false)
	}
	
	
	
	
}
