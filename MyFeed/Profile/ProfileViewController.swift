//
//  ProfileViewController.swift
//  MyFeed
//
//  Created by Lakshmi K on 31/01/22.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var profileTable: UITableView!
    
    let profileItems = ["Saved" , "Share" , "About Us","Logout"]
    let profileIconNames = ["bookmark.fill","paperplane.fill","person.3.fill","power"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTable.register(UINib(nibName: profileCellNib, bundle: nil), forCellReuseIdentifier: profileCellIdentitfier)
        profileTable.isScrollEnabled = false
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileLabelSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: profileCellIdentitfier, for: indexPath) as! ProfileCell
        profileCell.menuLabel.text = profileItems[indexPath.row]
        profileCell.menuIcon.image = UIImage(systemName: profileIconNames[indexPath.row])
        return profileCell
    }
    
    

}
