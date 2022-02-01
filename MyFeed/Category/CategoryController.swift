//
//  CategoryController.swift
//  MyFeed
//
//  Created by Lakshmi K on 31/01/22.
//

import UIKit

class CategoryController: UIViewController {
    @IBOutlet weak var categoryCollectioView: UICollectionView!
    @IBOutlet weak var categoryNewsTables: UITableView!
    
    var categoryList = ["Business", "Political" , "Sports" , "Medical" , "Entertainment" , "International"]
    var categoryIcons = ["business" ,"politics" ,  "sports", "medical","entertainment" , "international"]
    var newsFeedData : [NewsFeed] = []
    var categorySelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryCollectioView.register(UINib(nibName: categoryCellNib, bundle: nil), forCellWithReuseIdentifier: categoryCellIdentifier)
        loadNewsData()
        categoryNewsTables.backgroundColor = .clear
        categoryNewsTables.register(UINib(nibName: homeNewsCellNib, bundle: nil), forCellReuseIdentifier: homeCellIdentifier)
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
                    self.categoryNewsTables.reloadData()
                }
            } catch let error {
                print(error)
            }

        }
    }
    
    @IBAction func categoryScrollToEnd(_ sender: Any) {
        let collectionBounds = self.categoryCollectioView.bounds
        
        let contentOffset = CGFloat(floor(self.categoryCollectioView.contentOffset.x + collectionBounds.size.width))
               
        let frame: CGRect = CGRect(x : contentOffset ,y : self.categoryCollectioView.contentOffset.y ,width : self.categoryCollectioView.frame.width,height : self.categoryCollectioView.frame.height)
        
        self.categoryCollectioView.scrollRectToVisible(frame, animated: true)
    }
    
       
}

extension CategoryController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
        categoryCell.categoryIcon.image = UIImage(named: categoryIcons[indexPath.row])
        if indexPath.row == categorySelectedIndex {
            categoryCell.categoryName.textColor = whiteTextColor
            categoryCell.categoryIcon.setImageColor(color: whiteTextColor)
        }
        else {
            categoryCell.categoryName.textColor = greyTextColor
            categoryCell.categoryIcon.setImageColor(color: greyTextColor)
        }
        
        
        categoryCell.categoryName.text = categoryList[indexPath.row]
        
        
        
        return categoryCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categorySelectedIndex = indexPath.row
        categoryCollectioView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categorySize, height: categorySize)
    }
}


extension CategoryController : UITableViewDelegate , UITableViewDataSource {
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
    
    
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
