//
//  NoteViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/16.
//  Copyright © 2020 geonhyeong. All rights reserved.
//
import UIKit
import Foundation

class NoteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> Note Start")
        self.seupNavigation()
        
    }
    
    func seupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
    }
    
    
    @IBAction func openPhotoLibrary(_ sender: Any){
        let optionMenuAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //옵션 초기화
        let photoLibraryAction = UIAlertAction(title: "사진 보관함", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let newPhotoAction = UIAlertAction(title: "새로 촬영", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let linkAction = UIAlertAction(title: "외부 링크 이미지", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenuAlert.addAction(photoLibraryAction)
        optionMenuAlert.addAction(newPhotoAction)
        optionMenuAlert.addAction(linkAction)
        optionMenuAlert.addAction(cancelAction)
        
        //show
        self.present(optionMenuAlert, animated: true)
    }
}
