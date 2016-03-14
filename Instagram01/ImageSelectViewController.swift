//
//  ImageSelectViewController.swift
//  Instagram01
//
//  Created by 株式会社コアファイン on 2016/03/13.
//  Copyright © 2016年 eiichi.takamura. All rights reserved.
//

import UIKit


class ImageSelectViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    
    // ライブラリ（カメラロール）を指定してピッカーを開く
    @IBAction func handleLibraryButton(sender: AnyObject) {
        
        print( "handleLibraryButton" )
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    
    // カメラボタンを押したときに呼ばれるメソッド
    @IBAction func handleCameraButton(sender: AnyObject) {
        
        print( "handleCameraButton" )
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    // キャンセルボタンを押したときに呼ばれるメソッド
    @IBAction func handleCancelButton(sender: AnyObject) {
        print( "handleCancelButton" )
        // 画面を閉じる
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            dispatch_async(dispatch_get_main_queue()) {
                
                // AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.presentViewController(adobeViewController, animated: true, completion:  nil)
            }
        }
        
        // 閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
   
    // AdobeImageEditorで加工が終わったときに呼ばれる
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        // 画像加工画面を閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
        
        print( "photoEditor" )
        // 投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Post") as! PostViewController
        postViewController.image = image
        presentViewController(postViewController, animated: true, completion: nil)
    }
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
