//
//  connectionManager.swift
//  XYZInfo
//
//  Created by Antonius George on 10/9/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import SwiftMQTT

class connectionManager: NSObject {

	static let shared = connectionManager()
	
	private override init() {
		print("connectionManager Object initialized")
	}
}
