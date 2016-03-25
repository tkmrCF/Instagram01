//
//  commentViewController.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/24.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit
import Firebase

class commentViewController: UIViewController {

    var firebaseRef:Firebase!
    var postData: PostData?
 
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentTextview: UITextView!
    
    @IBAction func OKbutton(sender: AnyObject) {

        let imageString = postData!.imageString
        let name = postData!.name
        let caption = postData!.caption
        let likes = postData!.likes
        
        let time = (postData!.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval

        if commentTextview.text == "" {
            commentTextview.text = "いいね  "
        }
        let text:String = String(name! + " : " + commentTextview.text!)
 
        //postData?.comment.append(commentTextview.text)
        postData?.comment.append(text)
        let comms = postData!.comment
        
        
        // 辞書を作成してFirebaseに保存する
        let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comment": comms]
        
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        
        postRef.childByAppendingPath(postData!.id).setValue(post)
       
        // 画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        // 画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        commentName.text = "\(postData!.name!) : \(postData!.caption!)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
