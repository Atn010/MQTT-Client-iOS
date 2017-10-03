//
//  Data.swift
//  XYZInfo
//
//  Created by Antonius George on 10/3/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit

class Data: NSObject {
	override init() {
		clientID = Data.init().clientID
		clientPass = Data.init().clientPass
		verificationStatus = Data.init().verificationStatus
		
	}

	
	init(username: String, password: String) {
		clientID = username
		clientPass = password
		verificationStatus = false
	}
	var clientID: String
	var clientPass: String
	var	verificationStatus: Bool

}
