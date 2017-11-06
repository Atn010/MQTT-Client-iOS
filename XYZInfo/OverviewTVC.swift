//
//  OverviewTVC.swift
//  XYZInfo
//
//  Created by Antonius George on 10/2/17.
//  Copyright © 2017 Antonius GS. All rights reserved.
//

import UIKit

class OverviewTVC: UITableViewController{
	var itemArray: [String] = Data.shared.transferList
	var count = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if itemArray .isEmpty{
			connectionLogic.shared.transactionRequest()
			itemArray.append("Please wait while we are retriving Data from server")
		}else{
			
		}


    }
	@IBAction func onRefresh(_ sender: Any) {
		if(count >= 3){
			connectionLogic.shared.transactionRequest()
			count = 0
		}else{
			itemArray = Data.shared.transferList
			
			self.tableView.reloadData()
			
			count = count + 1
		}
		print(count)
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
