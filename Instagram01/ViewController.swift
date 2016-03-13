//
//  ViewController.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/13.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setupTab() **** Delete by 5.6 起動時にログインしていなければログイン画面を表示させる
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**  by 5.6 起動時にログインしていなければログイン画面を表示させる   **/
    override func viewWillAppear(animated: Bool) {
        // Firebaseを初期化して認証情報を取得する
        let firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        let authData = firebaseRef.authData
        
        // 認証情報=authData が無ければログインしていない
        if authData == nil {
            // ログインしていなければログインの画面を表示する
            // viewWillAppear内でpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
            
        } else {
            // authDataがnilでない場合は`setupTab`メソッドを呼び出してタブを表示させます。
            setupTab()
        }
        
        super.viewWillAppear(animated)
    }


    func setupTab() {
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor.init(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor.init(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
            self.presentViewController(imageViewController!, animated: true, completion: nil)
            }, atIndex: 1)
    }
    
    
    
}

