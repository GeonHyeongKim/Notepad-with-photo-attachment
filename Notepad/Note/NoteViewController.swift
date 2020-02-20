//
//  NoteViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/16.
//  Copyright © 2020 geonhyeong. All rights reserved.
//
import UIKit
import Photos

class NoteViewController: UIViewController {
    
    // Note View Model
    var noteViewModel: NoteEditViewModel = NoteEditViewModel()
    
    // Note
    @IBOutlet weak var importanceView: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContens: UITextView!
    var note: Note!
    
    // Editor
    @IBOutlet weak var editView: UIView!
    var currentEditorIndex: Int = 0 { // button의 tag를 이용
        willSet(newVal) {
            switch newVal {
            case 0:
                reload(status: .trash)
            case 1:
                reload(status: .importance)
            case 2:
                reload(status: .camera)
            case 3:
                reload(status: .textColor)
            case 4:
                reload(status: .newNote)
            default:
                reload(status: .write)
            }
        }
    }
    
    // Trash
    @IBOutlet weak var selectTrashView: UIView!
    
    // Importance
    @IBOutlet weak var selectImportanceView: UIView!
    @IBOutlet var importanceEditView: UIView!
    
    // Camera
    @IBOutlet weak var selectCameraView: UIView!
    
    // TextColor
    @IBOutlet weak var selectTextColorView: UIView!
    @IBOutlet var textColorEditView: UIView!
    
    // NewNote
    @IBOutlet weak var selectNewNoteView: UIView!
    
    var selectedPhotos: Set<UIImage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> Note Start")
        
        self.setup()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload(status: .write)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let selectedPhotos = selectedPhotos else {
            return
        }
        
        print(selectedPhotos)
    }
    
    // 초기 설정
    private func setup(){
        self.setupNavigation()
        self.setupNote()
    }
    
    // Navigation 설정
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
    }
    
    // 저장된 노트 정보 입력
    func setupNote(){
        if note != nil {
            self.importanceView.backgroundColor = note.importance
            self.txtTitle.text = note.title
            self.txtContens.text = note.conetent
        }
    }
    
    private func reload(status: NoteEditViewModel.Status) {
        noteViewModel.reload(status: status)
        
        // Navigation
        self.navigationController?.title = noteViewModel.navigationTitle
        
        // select View Hidden
        selectTrashView.isHidden = noteViewModel.isHiddenTrashView
        selectImportanceView.isHidden = noteViewModel.isHiddenImportanceView
        selectCameraView.isHidden = noteViewModel.isHiddenCameraView
        selectTextColorView.isHidden = noteViewModel.isHiddenTextColorView
        selectNewNoteView.isHidden = noteViewModel.isHiddenNewNoteView
        
        // Edit Area View Hidden
        editView.isHidden = noteViewModel.isHiddenEditView
        
        for view in editView.subviews {
            view.removeFromSuperview()
        }
        
        // 각 버튼에 대한 기능
        switch status {
        case .write:
            print("write")
        case .trash:
            print("trash")
        case .importance:
            print("importance")
        case .camera:
            self.openPhotoLibrary()
        case .textColor:
            print("textColor")
        case .newNote:
            print("newNote")
        }
        
        let editContentView: UIView
        switch status {
        case .importance:
            editContentView = importanceEditView
        case .textColor:
            editContentView = textColorEditView
        default:
            editContentView = UIView()
            editContentView.isHidden = true
        }
        
        editView.addSubview(editContentView)
        editView.addConstraintsFitParentView(editContentView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 임시
        if(segue.identifier == "showPhotoLibrary"){
            let photoLibraryViewController = segue.destination as? PhotoLibraryViewController
            photoLibraryViewController?.photoDelegate = self // photo data 받아오기
        }
    }
    
    // Edit 버튼에 대한 각각의 Action
    @IBAction func touchPageMenuButton(_ sender: UIButton) {
        let pageIndex = sender.tag
        currentEditorIndex = pageIndex
    }
    
    // 저장
    @IBAction func saveNote(_ sender: Any){
        
        if self.txtTitle.text != nil {
            dataCenter.noteList[0].title = self.txtTitle.text!
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Camera
    func openPhotoLibrary(){
        let optionMenuAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //옵션 초기화
        let photoLibraryAction = UIAlertAction(title: "사진 보관함", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkPhotoLibraryAuthorizationStatus()
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
    
    // photo library 권한 확인
    private func checkPhotoLibraryAuthorizationStatus(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async { () -> Void in // Tread 처리
                    self.performSegue(withIdentifier: "showPhotoLibrary", sender: nil)
                }
            case .denied, .restricted:
                self.alertPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { status in
                    guard status == .authorized else { return }
                    self.performSegue(withIdentifier: "showPhotoLibrary", sender: nil)
                }
            @unknown default:
                print("Photo Library Authorization Status에서 에러발생")
            }
        }
    }
    
    // 권한 설정 알림
    private func alertPhotoLibrary() {
        DispatchQueue.main.sync {
            let myAlert = UIAlertController(title: "사진 보관함에 접근 불가", message: "사진 보관함에 접근할 수 있도록, 앱 개인 정보 설정으로 이동하여 접근 허용해 주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
    }
}

// MARK: - NoteViewControllerDeleagate
extension NoteViewController: SendPhotoDataDelegate {
    func sendPhoto(photos: Set<UIImage>) {
        self.selectedPhotos = photos
    }
}
