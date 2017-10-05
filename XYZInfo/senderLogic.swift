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
	
	func publishMessage(Topic: String, Payload: String){
		let Message = CocoaMQTTMessage(topic: Topic, string: Payload, qos: Qos!, retained: false, dup: false)
		mqtt.publish(Message)
	}
	
	func verificationRequest(){
		
		let dateFormatter = DateFormatter()
		let nowDate = Date()
		
		dateFormatter.dateFormat = "dd/MM/yy HH:mm"
		let dateTime = dateFormatter.string(from: nowDate)
		
		let payload: String = dateTime+"~"+Data.shared.clientID+"~"+Data.shared.clientPass
		
		publishMessage(Topic: topicVerificationRequest,Payload: payload)
		
		Data.shared.verificationStatus = false
		Data.shared.currentVerificationDate = dateTime
	}
	
	func transactionRequest(){
		publishMessage(Topic: topicTransactionRequest, Payload: "request")
	}
	
	func transferRequest(Recipient: String, Amount: String){
		let dateFormatter = DateFormatter()
		let nowDate = Date()
		
		dateFormatter.dateFormat = "dd/MM/yy HH:mm"
		let dateTime = dateFormatter.string(from: nowDate)
		
		let payload: String = dateTime+"~"+Data.shared.clientID+"~"+Recipient+"~"+Amount
		
		publishMessage(Topic: topicVerificationRequest,Payload: payload)
		
		Data.shared.transferStatus = false
		Data.shared.currentTransferDate = dateTime
	}
	
	
	
}
