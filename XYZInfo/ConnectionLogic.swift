//
//  ConnectionLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT

class receiverLogic: CocoaMQTTDelegate {
	func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
		<#code#>
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
		<#code#>
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
		<#code#>
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
		<#code#>
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
		<#code#>
	}
	
	func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
		<#code#>
	}
	
	func mqttDidPing(_ mqtt: CocoaMQTT) {
		<#code#>
	}
	
	func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
		<#code#>
	}
	
	func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
		<#code#>
	}
	

	func connect(){
	
	let clientID = "CocoaMQTT-"
	let mqtt = CocoaMQTT(clientID: clientID, host: "localhost", port: 1883)
	mqtt.username = "test"
	mqtt.password = "public"
	mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
	mqtt.keepAlive = 60
	mqtt.delegate = self
	mqtt.connect()
	}
}
