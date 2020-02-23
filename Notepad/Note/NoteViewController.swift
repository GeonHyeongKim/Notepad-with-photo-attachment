//
//  NoteViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/16.
//  Copyright © 2020 geonhyeong. All rights reserved.
//
import UIKit
import Photos

protocol SendNoteDataDelegate: class {
    func sendNote(note: NoteModel)
}

class NoteViewController: UIViewController {
    
    // Note View Model
    var noteViewModel: NoteEditViewModel = NoteEditViewModel()
    
    // Note data Delegate
    var noteDelegate: SendNoteDataDelegate?
    
    // Navigation
    @IBOutlet weak var btnNavtionRight: UIBarButtonItem!
    
    // Keyboard
    @IBOutlet weak var txtContentsBottomMargin: NSLayoutConstraint!
    
    // Note
    @IBOutlet weak var importanceView: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContents: UITextView!
    var note: NoteModel!
    
    // Editor
    @IBOutlet weak var editorHightConstranints: NSLayoutConstraint!
    @IBOutlet weak var editHightConstranints: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    var currentEditorIndex: Int = 0 { // button의 tag를 이용
        willSet(newVal) {
            switch newVal {
            case 0:
                reload(status: .trash)
            case 1:
                reload(status: .background)
            case 2:
                reload(status: .camera)
            case 3:
                reload(status: .textColor)
            case 4:
                reload(status: .newNote)
            case 5:
                reload(status: .importance)
            default:
                reload(status: .write)
            }
        }
    }
    
    // Trash
    @IBOutlet weak var selectTrashView: UIView!
    
    // Background
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var selectBackgroundView: UIView!
    @IBOutlet var bgColorEditView: UIView!
    var currentBgColorIndex: Int = 1 // 현재 중요도 색상
    let colorList: [UIColor] = [
        UIColor(hexString: "#FFFFFF"), UIColor(hexString: "#000000"), UIColor(hexString: "#489CFF"), UIColor(hexString: "#53C14B"), UIColor(hexString: "#FACE15"),
        UIColor(hexString: "#FFBB00"), UIColor(hexString: "#FF5E00"), UIColor(hexString: "#FF007F"), UIColor(hexString: "#8041D9" as String)
    ]
    
    // Camera
    @IBOutlet weak var selectCameraView: UIView!
    var selectedPhotos: Set<UIImage>!
    
    // TextColor
    @IBOutlet weak var selectTextColorView: UIView!
    @IBOutlet var textColorEditView: UIView!
    
    // NewNote
    @IBOutlet weak var selectNewNoteView: UIView!
    
    // Importance
    @IBOutlet var importanceEditView: UIView!
    var currentImportanceColorIndex: Int = 0 // 현재 중요도 색상
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> Note Start")
        
        self.setup()        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let selectedPhotos = selectedPhotos else {
            return
        }
        
        print(selectedPhotos)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      unregisterForKeyboardNotifications()
    }
    
    // 초기 설정
    private func setup(){
        self.setupNavigation()
        self.setupNote()
        self.notification()
    }
    
    // Navigation 설정
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
    }
    
    // 저장된 노트 정보 입력
    func setupNote(){
        reload(status: .normal)
        self.importanceView.backgroundColor = note.importance
        self.txtContents.text = note.content
        self.backgroundView.backgroundColor = note.background
        
        if note.title == "제목 없음"{
            self.txtTitle.text = ""
        } else {
            self.txtTitle.text = note.title
        }
        
        if note.content == "내용 입력"{
            self.txtContents.textColor = UIColor.lightGray
        }
    }
    
    func notification() {
        registerForKeyboardNotifications()
    }
        
    private func reload(status: NoteEditViewModel.Status) {
        noteViewModel.reload(status: status)
        
        // Navigation
        self.navigationController?.navigationBar.topItem?.title = noteViewModel.navigationTitle
        self.btnNavtionRight.title = noteViewModel.navigationItemRightTitle
        
        // select View Hidden
        selectTrashView.isHidden = noteViewModel.isHiddenTrashView
        selectBackgroundView.isHidden = noteViewModel.isHiddenBackGroundView
        selectCameraView.isHidden = noteViewModel.isHiddenCameraView
        selectTextColorView.isHidden = noteViewModel.isHiddenTextColorView
        selectNewNoteView.isHidden = noteViewModel.isHiddenNewNoteView

        // Edit Area View Hidden
        editView.isHidden = noteViewModel.isHiddenEditView
        editorHightConstranints.constant = CGFloat(noteViewModel.editorHightConstranint)
        editHightConstranints.constant = CGFloat(noteViewModel.editHightConstranint)
        
        for view in editView.subviews {
            view.removeFromSuperview()
        }
        
        // 각 버튼에 대한 기능
        switch status {
        case .normal:
            print("normal")
        case .write:
            print("write")
        case .trash:
            self.presentDeleteAlert(title: "메모를 삭제 하겠습니까?", message: "")
        case .background:
            self.dismissKeyboardWhenTouchedAround()
        case .camera:
            self.openPhotoLibrary()
        case .textColor:
            print("textColor")
        case .newNote:
            self.newNote()
        case .importance:
            self.dismissKeyboardWhenTouchedAround()
        }
        
        let editContentView: UIView
        switch status {
        case .background:
            editContentView = bgColorEditView
        case .textColor:
            editContentView = textColorEditView
        case .importance:
            editContentView = importanceEditView
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
    
    // 권한 설정 알림
    private func presentAlertForSync(title: String, message: String, isDeleteAcion: Bool = false) {
        DispatchQueue.main.sync {
            let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "설정", style: .cancel){ (action) in // 다시 설정에서 허용할 수 있도록
                let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            myAlert.addAction(settingAction)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
        }
    }
    
    private func presentDeleteAlert(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // delete button을 눌렀을 경우 - ok 버튼을 눌르면 삭제
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            self.deleteNote(noteId: self.note.id)
        }
        let cancelAction = UIAlertAction(title: "cancle", style: .cancel) {(action) in
            self.reload(status: .normal)
        }
        myAlert.addAction(cancelAction)
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
    }
    
    // Edit 버튼에 대한 각각의 Action
    @IBAction func touchPageMenuButton(_ sender: UIButton) {
        let pageIndex = sender.tag
        currentEditorIndex = pageIndex
    }
    
    // 저장 및 완료
    @IBAction func finishNote(_ sender: Any){
        if self.btnNavtionRight.title == "저장" {
            self.saveNote()
            self.navigationController?.popViewController(animated: true)
        } else { // 완료
            reload(status: .normal)
            self.dismissKeyboardWhenTouchedAround()
        }
    }
    // MARK: - keyboard 설정
    @objc func keyboardWillShow(_ noti: Notification) {
        let notiInfo = noti.userInfo!
        
        //키보드 높이 가져오기 위해
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        txtContentsBottomMargin.constant = -height + editorHightConstranints.constant
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
   
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.txtContentsBottomMargin.constant = -height + self.editorHightConstranints.constant
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ noti: Notification) {
        let notiInfo = noti.userInfo!
        
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.txtContentsBottomMargin.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboardWhenTouchedAround()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Keyboard dismiss
    func dismissKeyboardWhenTouchedAround(){
        txtTitle.resignFirstResponder()
        txtContents.resignFirstResponder()
    }
    
    // 옵저버 등록
    func registerForKeyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
     // 옵저버 등록 해제
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Trash
    private func deleteNote(noteId: Int){
        db.deleteByID(id: noteId)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - BackGround
    @IBAction func touchBackGroundColorPicker(_ sender: UIButton) {
        self.currentBgColorIndex = sender.tag
        self.backgroundView.backgroundColor = self.colorList[currentBgColorIndex]
    }

    // MARK: - Camera
    func openPhotoLibrary(){
        let optionMenuAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 옵션 초기화
        let photoLibraryAction = UIAlertAction(title: "사진 보관함", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkPhotoLibraryAuthorizationStatus()
        })
        let newPhotoAction = UIAlertAction(title: "새로운 촬영", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let linkAction = UIAlertAction(title: "외부 링크 이미지", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.reload(status: .normal)
        })
        
        optionMenuAlert.addAction(photoLibraryAction)
        optionMenuAlert.addAction(newPhotoAction)
        optionMenuAlert.addAction(linkAction)
        optionMenuAlert.addAction(cancelAction)
        
        //show
        self.present(optionMenuAlert, animated: true)
    }
    
    // 새로운 촬영
    func openCamera(){
        let imgaePicker = UIImagePickerController()
        imgaePicker.sourceType = .camera
        imgaePicker.allowsEditing = true
        imgaePicker.delegate = self
        present(imgaePicker, animated: true)
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
                let title = "사진 보관함에 접근 불가"
                let message = "사진 보관함에 접근할 수 있도록, 앱 개인 정보 설정으로 이동하여 접근 허용해 주세요."
                self.presentAlertForSync(title: title, message: message)
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
    
    // MARK: - New Note
    private func newNote() {
        self.saveNote()
        self.clearNote()
        db.insertNote(id: 0, title: note.title, content: note.content, lastDate: currentDate(), importance: note.importance, background: note.background)
        self.note.id = db.readLast().id
    }
    
    // DB에 Note 정보 업데이트
    private func saveNote() {
        if note.title == "" { // 제목이 없을 경우
            note.title = "제목 없음"
        }
        
        if note.content == "" || note.content == "내용 입력" { // 내용이 없을 경우
            note.content = "내용 없음"
        }
        db.update(id: note.id, title: note.title, content: note.content, lastDate: currentDate(), importance: colorList[currentImportanceColorIndex], background: colorList[currentBgColorIndex])
    }
    
    private func clearNote() {
        self.txtTitle.text = ""
        self.note.title = txtTitle.text!
        self.txtContents.text = "내용 입력"
        self.note.content = txtContents.text!
        self.txtContents.textColor = UIColor.lightGray
        self.importanceView.backgroundColor = .white
        self.backgroundView.backgroundColor = .black
    }
    
    // 현재 날짜
    func currentDate() -> String{
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: now as Date)
    }
    
    // MARK: - Importance
    @IBAction func touchImportanceColorPicker(_ sender: UIButton) {
        self.currentImportanceColorIndex = sender.tag
        self.importanceView.backgroundColor =  self.colorList[currentImportanceColorIndex]
    }
}
// MARK: - NoteViewControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
    }
}
// MARK: - NoteViewControllerDelegate
extension NoteViewController: SendPhotoDataDelegate {
    
    func sendPhoto(photos: Set<UIImage>) {
        self.selectedPhotos = photos
    }
}
// MARK: - UITextFieldDelegate
extension NoteViewController: UITextFieldDelegate {
    
     // title 편집을 시작될때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        reload(status: .write)
    }
    
    // title 편집이 끝날때
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.note.title = txtTitle.text!
        reload(status: .normal)
    }
}
// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    
    // contents 편집을 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
        reload(status: .write)
        textContentsSetupView()
    }
    
    // contents 편집이 끝날때
    func textViewDidEndEditing(_ textView: UITextView) {
        reload(status: .normal)
        if txtContents.text == "" {
            textContentsSetupView()
        } else {
            self.note.content = txtContents.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    // UITextView PlaceHolder 설정
    func textContentsSetupView() {
        if txtContents.text == "" {
            txtContents.text = "내용 입력"
            txtContents.textColor = UIColor.lightGray
        } else if txtContents.text == "내용 입력"{
            txtContents.text = ""
            txtContents.textColor = UIColor.white
        }
    }
}


