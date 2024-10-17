//
//  MenuViewController.swift
//  Project4.2
//
//  Created by Валерия Беленко on 17/10/2024.
//

import UIKit

class MenuViewController: UITableViewController {
    var websites = ["github.com", "apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open page.."
        navigationController?.navigationBar.prefersLargeTitles = true
        
        print(websites)
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
                cell.textLabel?.text = websites[indexPath.row]
                return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            vc.selectedWebsite = websites[indexPath.row]
            vc.totalWebsites = websites.count
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}
