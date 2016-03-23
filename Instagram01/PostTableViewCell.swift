//
//  PostTableViewCell.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/14.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!


    
    var postData: PostData?

    override func awakeFromNib() {
        //print("PostTableViewCell.awakeFromNib")
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        //print("PostTableViewCell.setSelected")
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 表示されるときに呼ばれるメソッドをオーバーライドしてデータをUIに反映する
    override func layoutSubviews() {

        
        //print("PostTableViewCell.layoutSubviews")
        postImageView.image = postData!.image
        captionLabel.text = "\(postData!.name!) : \(postData!.caption!)"
        
        let likeNumber = postData!.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(postData!.date!)
        dateLabel.text = dateString
        
        if postData!.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }
  
        
        super.layoutSubviews()
    }
  
    
}
