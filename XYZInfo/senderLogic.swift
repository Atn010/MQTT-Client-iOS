//
//  senderLogic.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import CocoaMQTT

class senderLogic: NSObject {

	func connect() {
		
		let clientID = "username"
		let mqtt = CocoaMQTT(clientID: clientID, host: "192.168.56.101", port: 1883)
		mqtt.autoReconnect = true
		mqtt.cleanSession = false
		mqtt.allowUntrustCACertificate = true
		mqtt.keepAlive = 60
		mqtt.delegate = self as? CocoaMQTTDelegate
		mqtt.connect()
	}
}
