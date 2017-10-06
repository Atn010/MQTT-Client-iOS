//
//  ConnectionLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit


class receiverLogic: CocoaMQTTDelegate {
	func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
		
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
		
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
		
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
		
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
		
	}
	
	func mqttDidPing(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
		
	}
	
	func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
		
	}
	


}
