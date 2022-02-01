//
//  ViewController.swift
//  MyFeed
//
//  Created by Lakshmi K on 17/11/21.
//

import UIKit


// C5C9D2 - text color
// 9599A6 - icon colors
// 050507 - bg color 31323B
// 34B4F6 - highlight icon color
class ViewController: UIViewController {
    
    @IBOutlet weak var introDescription: UILabel!
    @IBOutlet weak var introHeading: UILabel!
    @IBOutlet weak var introImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipAction(_ sender: Any) {
        let homeController = storyboard?.instantiateViewController(withIdentifier: homeIdentifier) as! HomeController
        self.navigationController?.pushViewController(homeController, animated: true)
    }
}

