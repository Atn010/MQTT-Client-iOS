//
//  OverviewTVC.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class OverviewTVC: UITableViewController{
	var itemArray: [String] = Data.shared.transferList

    override func viewDidLoad() {
        super.viewDidLoad()
		connectionLogic.shared.transactionRequest()
		if itemArray .isEmpty{
			itemArray.append("Please wait while we are retriving Data from server")
		}


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
    }



}
