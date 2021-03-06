//
//  HomeViewController.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/14.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    var firebaseRef:Firebase!
    var postArray: [PostData] = []

    
    /*
    セクションの数を返す. 【＝課題対応用＝】
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // 登録されている写真の枚数分　セクションを作る
        return postArray.count
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("HomeViewController.viewDidLoad")
        // UITableViewを準備する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // コメント用Cell名の登録.　【＝課題対応用＝】
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "comCell")
        
        
        // Firebaseの準備をする
        firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        
        // 要素が追加されたらpostArrayに追加してTableViewを再表示する
        firebaseRef.childByAppendingPath(CommonConst.PostPATH).observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: self.firebaseRef.authData.uid)
            self.postArray.insert(postData, atIndex: 0)
            
            //print("HomeViewController.tableView.reloadData:",postData.caption )
            // TableViewを再表示する
            self.tableView.reloadData()
        })
        
        // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
        firebaseRef.childByAppendingPath(CommonConst.PostPATH).observeEventType(FEventType.ChildChanged, withBlock: { snapshot in
            
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: self.firebaseRef.authData.uid)
            
            // 保持している配列からidが同じものを探す
            var index: Int = 0
            for post in self.postArray {
                if post.id == postData.id {
                    index = self.postArray.indexOf(post)!
                    break
                }
            }
            
            var like_flag = true
            if postData.isLiked == self.postArray[index].isLiked {
                // LIKEボタンが押されていない
                like_flag = false
            }
            
            //print("HomeViewController.postArray.removeAtIndex")
            // 差し替えるため一度削除する
            self.postArray.removeAtIndex(index)

            
            // 削除したところに更新済みのでデータを追加する
            self.postArray.insert(postData, atIndex: index)

            
            // 【＝課題対応用＝】 この処理の修正がうまく　できない。　ここで落ちてしまう。
            // TableViewの該当セルだけを更新する
            //let indexPath = NSIndexPath(forRow: index, inSection: 0)       

            if like_flag == true {   //　LIKEボタンが押された時のみ該当セルを更新する
                
                /**** この処理だと　うまく動かない。落ちる。
                let indexPath = NSIndexPath(forRow: 0, inSection: index )
               　self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                *****/
                
                self.tableView.reloadData()
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("postArray.count:", postArray.count)
        //return postArray.count　  // 課題前
        let postData = postArray[section]
        return (postData.comment.count + 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("HomeViewController.cellForRowAtIndexPath")
        
        let aaa = indexPath.section
        let bbb = indexPath.row
        
        print( "====================================aaa:", aaa,  "bbb:", bbb )
        
        if bbb == 0 {  //【＝課題前の処理＝】
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        
            //cell.postData = postArray[indexPath.row]
            // VVVVVVV セクションに置き換え【＝課題対応用＝】
            cell.postData = postArray[indexPath.section]
            
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:"handleButton:event:", forControlEvents:  UIControlEvents.TouchUpInside)
            
            // セル内のボタンのアクションをソースコードで設定する
            cell.commentButton.addTarget(self, action:"textButton:event:", forControlEvents:  UIControlEvents.TouchUpInside)
    
            // UILabelの行数が変わっている可能性があるので再描画させる
            cell.layoutIfNeeded()
            
            return cell
        }else{
            
            /***
            課題対応　コメントが追加されたときのCell
            ***/
            
            let cell = tableView.dequeueReusableCellWithIdentifier("comCell", forIndexPath: indexPath)
            
            // cell.textLabel?.text = "OK"
            let postData = postArray[indexPath.section]
            cell.textLabel?.text = postData.comment[indexPath.row-1]
            cell.textLabel!.font = UIFont(name: "Arial", size: 10)
            return cell
        }
    }
    
    
    // 【＝課題対応用＝】
    func textButton(sender: UIButton, event:UIEvent){
        
        //print("HomeViewController.handleButton")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        //let uid = firebaseRef.authData.uid
        
        let aaa = indexPath?.section
        let bbb = indexPath?.row
        
        print( "textButton" ,aaa, bbb )
        
        // コメント入力画面のインスタンス生成
        // 注意！！　クラス名とインスタンス名が同一だったので、混同されて、postDataプロパティが表示されなかった。
        let commentViewController2 = self.storyboard?.instantiateViewControllerWithIdentifier("CommentInputView") as! commentViewController
        
        commentViewController2.firebaseRef = self.firebaseRef
        commentViewController2.postData = postArray[indexPath!.section]
        
        // コメント入力画面を開く
        self.presentViewController(commentViewController2 , animated: true, completion: nil)
    }

    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("HomeViewController.didSelectRowAtIndexPath")
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // ＞＞＞＞＞　like-Button　を押された時の処理　＜＜＜＜＜
    // セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event:UIEvent) {
        
        //print("HomeViewController.handleButton")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
         print("postArray[",indexPath!.section)
        
        // 配列からタップされたインデックスのデータを取り出す
        //let postData = postArray[indexPath!.row]
        let postData = postArray[indexPath!.section]
        
        // Firebaseに保存するデータの準備
        let uid = firebaseRef.authData.uid
        
        if postData.isLiked {
            // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
            var index = -1
            for likeId in postData.likes {
                if likeId == uid {
                    // 削除するためにインデックスを保持しておく
                    index = postData.likes.indexOf(likeId)!
                    break
                }
            }
            postData.likes.removeAtIndex(index)
        } else {
            postData.likes.append(uid)
        }
        
        let imageString = postData.imageString
        let name = postData.name
        let caption = postData.caption  // https://techacademy.s3.amazonaws.com/bootcamp/iphone/instagram/"

        
        let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
        let likes = postData.likes
        let comms = postData.comment
        
        // 辞書を作成してFirebaseに保存する
        let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comment": comms]
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        postRef.childByAppendingPath(postData.id).setValue(post)
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
