//
//  Data.swift
//  XYZInfo
//
//  Created by Antonius George on 10/3/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit

class Data: NSObject {
	static let shared = Data()
	
	private override init() {
		print("Data Object initialized")
	}
	
	var transferList: [String] = []
	var moneyAmount: String = ""
	
	var clientID: String = ""
	var clientPass: String = ""
	
	var currentVerificationDate : String = ""
	var	verificationStatus: Int = 0
	
	var currentTransferDate : String = ""
	var transferStatus: Int = 0
	
	var notReady : Bool = true

}
