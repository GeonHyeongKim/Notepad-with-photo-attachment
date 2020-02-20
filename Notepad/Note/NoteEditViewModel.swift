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
    
    init() {
        status = .write
    }
    
    func reload(status: Status) {
        switch status {
        case .write:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "수정"
            
        case .trash:
            isHiddenEditView = true
            isHiddenTrashView = false
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "삭제"
            
        case .importance:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenImportanceView = false
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "중요도"
            
        case .camera:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = false
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = "카메라 첨부"
            
        case .textColor:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = false
            isHiddenNewNoteView = true
            navigationTitle = "텍스트 색상"
            
        case .newNote:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = false
            navigationTitle = "새 메모"
        }
    }
}
