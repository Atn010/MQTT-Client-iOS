//
//  connectionLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/6/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT


class connectionLogic: NSObject {
	
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
	
	
	/// This Method configure the client with a predetermine setting
	func configure(){
		mqtt = CocoaMQTT(clientID: Data.shared.clientID, host: "192.168.56.101", port: 1883)
		
		mqtt.autoReconnect = true
		mqtt.cleanSession = false
		
		mqtt.delegate = self
		
		topicVerificationRequest = "verification/request/" + Data.shared.clientID
		topicVerificationResponse = "verification/response/" + Data.shared.clientID
		
		topicTransactionRequest = "transaction/request/" + Data.shared.clientID
		topicTransactionList = "transaction/list/" + Data.shared.clientID
		topicTransactionMoney = "transaction/money/" + Data.shared.clientID
		
		topicTransferRequest = "transfer/request/" + Data.shared.clientID
		topicTransferResponse = "transfer/response/" + Data.shared.clientID
	}
	
	/// This Method connects the Client to the Broker
	func connect() {
		print("Connect Attempt")
		mqtt.connect()
	}
	
	/// This Method subscribes the Client to a predetermine Topic
	func connectReady(){
		mqtt.subscribe(topicVerificationResponse)
		mqtt.subscribe(topicTransactionList)
		mqtt.subscribe(topicTransferResponse)
		mqtt.subscribe(topicTransactionMoney)
	}
	
	/// This Method publish the message with a preset
	///
	/// - Parameters:
	///   - Topic: The Topic for the broker and server
	///   - Payload: The Payload Message to be delivered
	func publishMessage(Topic: String, Payload: String){
		print("Publishing to topic: " + Topic + " | With Message: "+Payload)
		mqtt.publish(Topic, withString: Payload, qos: CocoaMQTTQOS.qos1, retained: false, dup: false)
	}
	
	/// This Method get and format the current date
	///
	/// - Returns: The Date in a String with a format
	func getCurrentDate() -> String{
		let dateFormatter = DateFormatter()
		let nowDate = Date()
		
		dateFormatter.dateFormat = "dd/MM/yy HH:mm"
		let dateTime = dateFormatter.string(from: nowDate)
		
		return dateTime
	}
	
	/// This method sends a verification request to the Server thru the Broker
	///
	/// The Request is configured with the parameter and store the necessary information for response verification
	/// Publish the Request to the Server thru the Broker
	func verificationRequest(){
		let payload: String = getCurrentDate()+"~"+Data.shared.clientID+"~"+Data.shared.clientPass
		
		Data.shared.verificationStatus = 0
		Data.shared.currentVerificationDate = getCurrentDate()
		
		print("Verification attempt")
		
		publishMessage(Topic: topicVerificationRequest,Payload: payload)

	}
	
	
	/// This method sends a request to the Server thru the Broker
	func transactionRequest(){
		print("Request transaction list")
		publishMessage(Topic: topicTransactionRequest, Payload: "request")
	}
	
	/// This method sends a Transfer Request to the Server thru the Broker
	///
	/// - Parameters:
	///   - Recipient: This is the Recipient (Target) of the Transfer
	///   - Amount: This is the Amount of money wished to be Transfer
	///
	/// The Request is configured with the parameter and store the necessary information for response verification
	/// Publish the Request to the Server thru the Broker
	func transferRequest(Recipient: String, Amount: String){
		
		let payload: String = getCurrentDate()+"~"+Data.shared.clientID+"~"+Recipient+"~"+Amount
		
		Data.shared.currentTransferDate = getCurrentDate()
		Data.shared.transferStatus = 0
		print("Transfer Request Attempt")
		publishMessage(Topic: topicTransferRequest,Payload: payload)

	}
	
}


extension connectionLogic: CocoaMQTTDelegate{
	
	/// This Method receive acknowledgement when Connection between client and broker is established
	///
	/// - Parameters:
	///   - mqtt: the receiverCocoaMQTT
	///   - ack: the message of the acknowledgement
	func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
		if (ack == .accept) {
			connectReady()
			if (Data.shared.verifiedStatus == false){
				verificationRequest()
			}
		}
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
		print("The Message has Arrived into the server")
	}
	
	
	/// This Method processes the Verification
	///
	/// - Parameter payload: This is the message retrived from the broker
	///
	/// The Message is seperated into it's components
	/// The Message is checked whether or not the Date is correct and checks for the message and Execute the appropriate function
	fileprivate func processVerificationResponse(_ payload: String) {
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
	
	/// This Method processes the Transaction
	///
	/// - Parameter payload: This is the message retrived from the broker
	///
	/// The Message is processed by removing the first and last character and seperating the String of characters into a list
	/// The new list is then set as the list to be displayed to the User
	fileprivate func processTransactionList(_ payload: String) {
		Data.shared.transferList.removeAll()
		
		var rawList = payload
		rawList.removeFirst()
		rawList.removeLast()
		
		let transferlist = rawList.components(separatedBy: ", ")
		
		Data.shared.transferList = transferlist.reversed()
	}
	
	/// This Method process the message and retrive the amount of money from the message
	///
	/// - Parameter payload: This is the message retrived from the broker
	fileprivate func processAccountMoney(_ payload: String) {
		Data.shared.moneyAmount = payload
	}
	
	/// This Method processes the Transfer
	///
	/// - Parameter payload: This is the message retrived from the broker
	///
	/// The Message is seperated into it's components
	/// The Message is checked whether or not the Date is correct and checks for the message and Execute the appropriate function.
	fileprivate func processTransferResponse(_ payload: String) {
		let Message = payload.components(separatedBy: "~")
		
		let statusDate = Message[0]
		let statusMessage = Message[1]
		
		if(statusDate == Data.shared.currentVerificationDate){
			if(statusMessage == "confirmed"){
				Data.shared.transferStatus = 1
				transactionRequest()
			}
			
			if(statusMessage == "failed"){
				Data.shared.transferStatus = 2
			}
		}
	}

	/// This method receive the Message from the broker when connected
	///
	/// - Parameters:
	///   - mqtt: the receiverCocoaMQTT
	///   - message: the Message from the Broker
	///   - id: the indentification of the message
	func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
		
		let Topic: String = message.topic
		let payload: String = message.string!
		
		print("Topic: " + Topic + " | Message: " + payload)
		
		if (Topic == topicVerificationResponse){
			processVerificationResponse(payload)
		}
		if (Topic == topicTransactionList){
			processTransactionList(payload)
		}
		
		if (Topic == topicTransactionMoney){
			processAccountMoney(payload)
		}
		
		if (Topic == topicTransferResponse){
			processTransferResponse(payload)
		}
		
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
		Data.shared.notReady = false
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
	}
	
	func mqttDidPing(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
		print("Disconnected")
		Data.shared.notReady = true
	}
	
	
}
