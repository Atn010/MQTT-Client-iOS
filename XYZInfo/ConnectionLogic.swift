//
//  connectionLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/6/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT


class connectionLogic: NSObject, CocoaMQTTDelegate {
	
	static let shared = connectionLogic()
	
	private override init() {
		print("connectionLogic Object initialized")
	}
	
	
	var topicVerificationRequest: String = ""
	var topicVerificationResponse: String = ""
	
	var topicTransactionRequest: String = ""
	var topicTransactionList: String = ""
	var topicTransactionMoney: String = ""
	
	var topicTransferRequest: String = ""
	var topicTransferResponse: String = ""
	
	var mqtt = CocoaMQTT(clientID: Data.shared.clientID)
	
	
	func configure(){
		topicVerificationRequest = "verification/request/" + Data.shared.clientID
		topicVerificationResponse = "verification/response/" + Data.shared.clientID
		
		topicTransactionRequest = "transaction/request/" + Data.shared.clientID
		topicTransactionList = "transaction/list/" + Data.shared.clientID
		topicTransactionMoney = "transaction/money/" + Data.shared.clientID
		
		topicTransferRequest = "transfer/request/" + Data.shared.clientID
		topicTransferResponse = "transfer/response/" + Data.shared.clientID

	}
	
	func connect() {
		mqtt = CocoaMQTT(clientID: Data.shared.clientID, host: "192.168.56.101", port: 1883)
		mqtt.username=""
		mqtt.password=""
		
		mqtt.autoReconnect = true
		mqtt.autoReconnectTimeInterval = 5
		mqtt.cleanSession = true
		mqtt.allowUntrustCACertificate = true
		mqtt.enableSSL = false
		mqtt.keepAlive = 60
		mqtt.delegate = self
		mqtt.backgroundOnSocket = false
		mqtt.secureMQTT = false
		mqtt.willMessage = CocoaMQTTWill(topic: "will", message: "Dead")

		print("Connect Attempt")
		mqtt.connect()
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
	
	func publishMessage(Topic: String, Payload: String){
		
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
	
	
	
	
	
	func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
		if (ack == .accept) {
			connectReady()
			print("connected")
			if (Data.shared.verificationStatus  != 1){
				verificationRequest()
			}
		}
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
		print("message: "+message.string!+" Sent" )
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
		print("received")
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
		
		let Topic: String = message.topic
		let payload: String = message.string!
		print("topic: " + Topic)
		print("payload:" + payload)
		
		
		if (Topic == topicVerificationResponse){
			let Message = payload.components(separatedBy: "~")
			
			let statusDate = Message[0]
			let statusMessage = Message[1]
			
			print(statusDate + " VS. " + Data.shared.currentVerificationDate)
			print(statusMessage)
			
			if(statusDate == Data.shared.currentVerificationDate){
				if(statusMessage == "confirmed"){
					Data.shared.verificationStatus = 1
					transactionRequest()
				}
				
				if(statusMessage == "failed"){
					Data.shared.verificationStatus = 2
				}
				
			}
			
			
		}
		if (Topic == topicTransactionList){
			Data.shared.transferList.removeAll()
			
			var rawList = payload
			rawList.removeFirst()
			rawList.removeLast()
			
			let transferlist = rawList.components(separatedBy: ", ")
			
			Data.shared.transferList = transferlist
		}
		
		if (Topic == topicTransactionMoney){
			Data.shared.moneyAmount = payload
		}
		
		if (Topic == topicTransferResponse){
			let Message = payload.components(separatedBy: "~")
			
			let statusDate = Message[0]
			let statusMessage = Message[1]
			
			if(statusDate == Data.shared.currentVerificationDate){
				if(statusMessage == "confirmed"){
					Data.shared.transferStatus = 1
					
				}
				
				if(statusMessage == "failed"){
					Data.shared.transferStatus = 2
				}
				
			}
		}
		
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
		print("subcribed to "+topic)
		Data.shared.notReady = false
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
		print("unsubcribed")
	}
	
	func mqttDidPing(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
		print("Disconnected")
	}
	

}
