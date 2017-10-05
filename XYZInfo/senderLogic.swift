//
//  senderLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT
//import SwiftyPlistManager

class senderLogic: NSObject {
	
	
	let clientID: String = Data.shared.clientID
	
	let topicVerificationRequest: String = "verification\request\\" + Data.shared.clientID
	let topicVerificationResponse: String = "verification\response\\" + Data.shared.clientID
	
	let topicTransactionRequest: String = "transaction\request\\" + Data.shared.clientID
	let topicTransactionResponse: String = "transaction\response\\" + Data.shared.clientID
	
	let topicTransferRequest: String = "transfer\request\\" + Data.shared.clientID
	let topicTransferResponse: String = "transfer\response\\" + Data.shared.clientID
	
	let Qos = CocoaMQTTQOS(rawValue: 1)
	let mqtt = CocoaMQTT(clientID: Data.shared.clientID, host: "192.168.56.101", port: 1883)
	
	
	func connect() {
		mqtt.autoReconnect = true
		mqtt.autoReconnectTimeInterval = 3
		mqtt.cleanSession = false
		mqtt.allowUntrustCACertificate = true
		mqtt.keepAlive = 60
		mqtt.delegate = self as? CocoaMQTTDelegate
		mqtt.connect()
		
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionResponse)
		mqtt.subscribe(topicTransferResponse)
		
		
	}
	
	func verificationRequest(){
		let dateFormatter = DateFormatter()
		let nowDate = Date()
		
		dateFormatter.dateFormat = "dd/MM/yy HH:mm"
		let dateTime = dateFormatter.string(from: nowDate)
		
		let payload = dateTime+"~"+Data.shared.clientID+"~"+Data.shared.clientPass
		
		
		let Message = CocoaMQTTMessage(topic: topicVerificationRequest, string: payload, qos: Qos!, retained: false, dup: false)
		mqtt.publish(Message)
	}
	
	
	
	
}
