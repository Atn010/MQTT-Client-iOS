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
	
	
	var topicVerificationRequest: String = ""
	var topicVerificationResponse: String = ""
	
	var topicTransactionRequest: String = ""
	var topicTransactionList: String = ""
	var topicTransactionMoney: String = ""
	
	var topicTransferRequest: String = ""
	var topicTransferResponse: String = ""
	
	var mqtt: CocoaMQTT = CocoaMQTT(clientID: Data.shared.clientID)
	
	func configure(){
		topicVerificationRequest = "verification/request/" + Data.shared.clientID
		topicVerificationResponse = "verification/response/" + Data.shared.clientID
		
		topicTransactionRequest = "transaction/request/" + Data.shared.clientID
		topicTransactionList = "transaction/list/" + Data.shared.clientID
		topicTransactionMoney = "transaction/money/" + Data.shared.clientID
		
		topicTransferRequest = "transfer/request/" + Data.shared.clientID
		topicTransferResponse = "transfer/response/" + Data.shared.clientID
		
		mqtt = CocoaMQTT(clientID: Data.shared.clientID, host: "192.168.56.101", port: 1883)
	}
	
	func connect() {
		mqtt.username=""
		mqtt.password=""
		
		mqtt.autoReconnect = true
		mqtt.autoReconnectTimeInterval = 5
		mqtt.cleanSession = false
		mqtt.allowUntrustCACertificate = true
		mqtt.clientID = Data.shared.clientID
		mqtt.enableSSL = false
		mqtt.keepAlive = 60
		mqtt.delegate = receiverLogic.shared
		mqtt.backgroundOnSocket = false
		mqtt.secureMQTT = false
		mqtt.host = "192.168.56.101"
		mqtt.port = 1883
		mqtt.willMessage = CocoaMQTTWill(topic: "will", message: "Dead")
		
		mqtt.connect()
		print("Connect Attempt")
		
		
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionList)
		mqtt.subscribe(topicTransferResponse)
		mqtt.subscribe(topicTransactionMoney)
		
		mqtt.subscribe(topicVerificationRequest)
		mqtt.subscribe(topicTransactionRequest)
		mqtt.subscribe(topicTransferRequest)

		
	}
	func connectReady(){
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionList)
		mqtt.subscribe(topicTransferResponse)
		mqtt.subscribe(topicTransactionMoney)
		
		mqtt.subscribe(topicVerificationRequest)
		mqtt.subscribe(topicTransactionRequest)
		mqtt.subscribe(topicTransferRequest)
	}
	
	func isConnected() -> Bool{
		if (mqtt.connState.rawValue == 2){
			return true
		}
		
		return false
		
	}
	
	func publishMessage(Topic: String, Payload: String){
		
		mqtt.publish(Topic, withString: Payload, qos: CocoaMQTTQOS.qos1, retained: false, dup: false)
		//mqtt.publish(CocoaMQTTMessage.init(topic: Topic, string: Payload, qos: CocoaMQTTQOS.init(rawValue: 1)!, retained: false, dup: true))
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
		
		Data.shared.verificationStatus = 0
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
		
		Data.shared.transferStatus = 0
		Data.shared.currentTransferDate = dateTime
	}
	
	
	
}
