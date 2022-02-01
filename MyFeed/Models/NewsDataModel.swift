//
//  NewsDataModel.swift
//  MyFeed
//
//  Created by Lakshmi K on 08/12/21.
//

import Foundation


struct NewsFeed: Decodable {
    var source : String?
    var description : String?
    var time : String?
    var commentsCount : String?
    var likesCount : String?
    var dislikesCount : String?
    var imageName : String?
    var category : String?
}
