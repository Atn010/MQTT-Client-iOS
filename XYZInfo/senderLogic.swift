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
	
	let data = Data.shared
	
	let clientID: String = Data.shared.clientID
	
	let topicVerificationRequest: String = "verification\request\\" + Data.shared.clientID
	let topicVerificationResponse: String = "verification\response\\" + Data.shared.clientID
	
	let topicTransactionRequest: String = "transaction\request\\" + Data.shared.clientID
	let topicTransactionResponse: String = "transaction\response\\" + Data.shared.clientID
	
	let topicTransferRequest: String = "transfer\request\\" + Data.shared.clientID
	let topicTransferResponse: String = "transfer\response\\" + Data.shared.clientID
	
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
