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
		print("Object initialized")
	}
	
	var transferList:[String] = []
	
	var clientID: String = ""
	var clientPass: String = ""
	
	var currentVerificationDate : String = ""
	var currentTransferDate : String = ""
	var	verificationStatus: Bool = false
	
	var currentTransferDate : String = ""
	var transferStatus: Bool = false

}
