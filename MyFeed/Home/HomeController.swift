//
//  HomeController.swift
//  MyFeed
//
//  Created by Lakshmi K on 25/11/21.
//

import UIKit

class HomeController: UIViewController , CustomSegmentedControlDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var newsTable: UITableView!
    
    var newsFeedData : [NewsFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.categoryView.isHidden = true
        
        let segmentedController = CustomSegmentedControl(frame: CGRect(x: 10, y: 150, width: self.view.frame.size.width - 20, height: 55), buttonTitle: ["Home" , "Explore" , "Something"])
        segmentedController.backgroundColor = .clear
        segmentedController.delegate = self
        self.view.addSubview(segmentedController)
        
        newsTable.backgroundColor = .clear
        newsTable.register(UINib(nibName: homeNewsCellNib, bundle: nil), forCellReuseIdentifier: homeCellIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tapGesture)
        
        loadNewsData()
        
    }
    
   @objc func profileImageTapped() {
        let profileController = storyboard?.instantiateViewController(withIdentifier: profileIdentifier) as! ProfileViewController
        self.navigationController?.present(profileController, animated: true, completion: nil)
    }
    
    func loadNewsData() {
 
        
        if let path = Bundle.main.path(forResource: "news_model", ofType: "json") {
            do {
                let data = try Data.init(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let json_obj = jsonObject as? Dictionary<String , Array<AnyObject>>{
                    let newsArray = json_obj["news_feed"]!
                    
                    for eachNews in newsArray {
                        var eachN = NewsFeed()
                        eachN.source = eachNews["source"] as? String
                        eachN.description = eachNews["description"] as? String
                        eachN.commentsCount = eachNews["commentsCount"] as? String
                        eachN.likesCount = eachNews["likesCount"] as? String
                        eachN.time =  eachNews["time"] as? String
                        eachN.imageName = eachNews["imageName"] as? String
                        eachN.dislikesCount = eachNews["dislikesCount"] as? String
                        newsFeedData.append(eachN)
                    }
                    self.newsTable.reloadData()
                }
            } catch let error {
                print(error)
            }

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func changeToIndex(index: Int) {
        if index == 0 {
            self.categoryView.isHidden = true
        }
        else if index == 1 {
            self.categoryView.isHidden = false
            let categoryController = storyboard?.instantiateViewController(withIdentifier: categoryIdentifier) as! CategoryController
            addChild(categoryController)
            categoryView.addSubview(categoryController.view)
            categoryController.view.frame = categoryView.bounds
            categoryController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            categoryController.didMove(toParent: self)
        }
    }
    
}

extension HomeController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier, for: indexPath) as! HomeNewsCell
        newsCell.headingLabel.text = "\(newsFeedData[indexPath.row].source!)" + " .\(newsFeedData[indexPath.row].time!)h"
        newsCell.descriptionLabel.text = newsFeedData[indexPath.row].description!
        newsCell.commentCountLabel.text = newsFeedData[indexPath.row].commentsCount!
        newsCell.likeCountLabel.text =  newsFeedData[indexPath.row].likesCount!
        newsCell.dislikesCountLabel.text = newsFeedData[indexPath.row].dislikesCount!
        newsCell.newsImage.image = UIImage(named: newsFeedData[indexPath.row].imageName!)
        
        return newsCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return newsCellHeight
    }
    func getImage (named name : String) -> UIImage?
        {
            if let imgPath = Bundle.main.path(forResource: name, ofType: ".jpg")
            {
                return UIImage(contentsOfFile: imgPath)
            }
            return nil
        }
}


