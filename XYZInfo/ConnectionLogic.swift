//
//  connectionLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/6/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT
import CocoaAsyncSocket
import SwiftyTimer


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
		//mqtt.allowUntrustCACertificate = true
		mqtt.enableSSL = false
		mqtt.keepAlive = 60
		mqtt.delegate = self
		//mqtt.backgroundOnSocket = false
		mqtt.secureMQTT = false
		
		mqtt.clientID = Data.shared.clientID
		mqtt.host = "192.168.56.101"
		mqtt.port = 1883
		mqtt.willMessage = CocoaMQTTWill(topic: "will", message: "Dead")
		
		mqtt.connect()
		mqtt.ping()
		print("Connect Attempt")
		
		/*
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionList)
		mqtt.subscribe(topicTransferResponse)
		mqtt.subscribe(topicTransactionMoney)
		
		mqtt.subscribe(topicVerificationRequest)
		mqtt.subscribe(topicTransactionRequest)
		mqtt.subscribe(topicTransferRequest)
		*/
		
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
	
	
	
	
	
	func mqtt(_ mqtt: CocoaMQTT, didConnectAck: CocoaMQTTConnAck) {
		
		print(CocoaMQTTConnAck.accept)
		senderLogic.shared.connectReady()
		print("connected")
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
		
		if (Topic == senderLogic.shared.topicVerificationResponse){
			let Message = payload.components(separatedBy: "~")
			
			let statusDate = Message[0]
			let statusMessage = Message[1]
			
			if(statusDate == Data.shared.currentVerificationDate){
				if(statusMessage == "confirmed"){
					Data.shared.verificationStatus = 1
				}
				
				if(statusMessage == "failed"){
					Data.shared.verificationStatus = 2
				}
				
			}
			
			
		}
		if (Topic == senderLogic.shared.topicTransactionList){
			Data.shared.transferList.removeAll()
			
			var rawList = payload
			rawList.removeFirst()
			rawList.removeLast()
			
			let transferlist = rawList.components(separatedBy: ", ")
			
			Data.shared.transferList = transferlist
		}
		if (Topic == senderLogic.shared.topicTransactionMoney){
			Data.shared.moneyAmount = payload
		}
		if (Topic == senderLogic.shared.topicTransferResponse){
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
