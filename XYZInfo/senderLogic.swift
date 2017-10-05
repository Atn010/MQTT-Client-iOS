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
	static let shared = senderLogic()
	
	private override init() {
		print("senderLogic Object initialized")
	}
	
	let clientID: String = Data.shared.clientID
	
	let topicVerificationRequest: String = "verification/request/" + Data.shared.clientID
	let topicVerificationResponse: String = "verification/response/" + Data.shared.clientID
	
	let topicTransactionRequest: String = "transaction/request/" + Data.shared.clientID
	let topicTransactionList: String = "transaction/list/" + Data.shared.clientID
	let topicTransactionMoney: String = "transaction/money/" + Data.shared.clientID
	
	let topicTransferRequest: String = "transfer/request/" + Data.shared.clientID
	let topicTransferResponse: String = "transfer/response/" + Data.shared.clientID
	
	let mqtt = CocoaMQTT(clientID: Data.shared.clientID, host: "192.168.56.101", port: 1883)
	
	
	func connect() {
		mqtt.autoReconnect = true
		mqtt.autoReconnectTimeInterval = 3
		mqtt.cleanSession = false
		mqtt.allowUntrustCACertificate = true
		mqtt.keepAlive = 60
		mqtt.delegate = receiverLogic()
		mqtt.connect()
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionList)
		mqtt.subscribe(topicTransferResponse)
		mqtt.subscribe(topicTransactionMoney)
		
	}
	
	func isConnected() -> Bool{
		print(mqtt.connState.rawValue)
		if (mqtt.connState.rawValue == 1){
			return true
		}
		
		return false
		
	}
	
	func publishMessage(Topic: String, Payload: String){
		//let Message = CocoaMQTTMessage(topic: Topic, string: Payload, qos: CocoaMQTTQOS.qos1, retained: false)
		mqtt.publish(Topic, withString: Payload, qos: CocoaMQTTQOS.qos1, retained: false, dup: false)
		print("published to topic: "+Topic+" | And Payload: "+Payload)
	}
	
	func verificationRequest(){
		
		let dateFormatter = DateFormatter()
		let nowDate = Date()
		
		dateFormatter.dateFormat = "dd/MM/yy HH:mm"
		let dateTime = dateFormatter.string(from: nowDate)
		
		let payload: String = dateTime+"~"+Data.shared.clientID+"~"+Data.shared.clientPass
		print ("Message Configured with " + payload)
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
