//
//  commentViewController.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/24.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit

class commentViewController: UIViewController {

    var postData: PostData?
 
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentTextview: UITextView!
    @IBAction func OKbutton(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        // 画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //commentName.text = "\(postData!.name!) : \(postData!.caption!)"
        
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
