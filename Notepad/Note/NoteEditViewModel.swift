//
//  NoteEditViewModel.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/19.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

class NoteEditViewModel {
    var status: Status
    enum Status {
        case write
        case normal
        case trash
        case importance
        case camera
        case textColor
        case newNote
    }
    
    var isHiddenEditView = true
    var isHiddenTrashView = true
    var isHiddenImportanceView = true
    var isHiddenCameraView = true
    var isHiddenTextColorView = true
    var isHiddenNewNoteView = true
    var navigationTitle = ""
    var navigationItemRightTitle = ""
    
    init() {
        status = .write
    }
    
    func reload(status: Status) {
        switch status {
        case .normal:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "메모"
            navigationItemRightTitle = "저장"
        
        case .write:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "수정"
            navigationItemRightTitle = "완료"
                        
        case .trash:
            isHiddenEditView = true
            isHiddenTrashView = false
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "삭제"
            navigationItemRightTitle = "저장"
            
        case .importance:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenImportanceView = false
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "중요도"
            navigationItemRightTitle = "저장"
            
        case .camera:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = false
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "카메라 첨부"
            navigationItemRightTitle = "저장"
            
        case .textColor:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = false
            isHiddenNewNoteView = true
            navigationTitle = "텍스트 색상"
            navigationItemRightTitle = "저장"
            
        case .newNote:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = false
            navigationTitle = "새 메모"
            navigationItemRightTitle = "저장"

        }
    }
}
