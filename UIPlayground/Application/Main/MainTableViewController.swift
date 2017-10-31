//
//  MainTableViewController.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/24/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log

class MainTableViewController: UITableViewController {
    
    struct RowPositions {
        static let tabs         = 0
        static let pages        = 1
        static let tableView    = 2
        static let form         = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log("click at %d", indexPath.row)
        switch indexPath.row {
        case RowPositions.tabs:
           // let tabsSB = UIStoryboard(name: "Tabs", bundle: nil)
           // let tabsVC = tabsSB.instantiateViewController(withIdentifier: <#T##String#>)  //TabsViewController()
            //present(tabsVC, animated: true, completion: nil)
            break
        case RowPositions.pages:
            break
        case RowPositions.tableView:
            break
        case RowPositions.form:
            break
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        
        if let tab = destination as? TabsViewController {
            os_log("Prepage for tab")
        } else if let firstTab = destination as? FirstTabViewController {
              os_log("Prepage for first tab")
        } else if let form = destination as? FormViewController {
           os_log("Prepage for form")
            //form.title = "FORM NAME"
        }
    }

}
