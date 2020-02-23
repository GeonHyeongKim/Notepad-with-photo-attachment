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
        case background
    }
    
    var isHiddenEditView = true
    var isHiddenTrashView = true
    var isHiddenBackGroundView = true
    var isHiddenCameraView = true
    var isHiddenTextColorView = true
    var isHiddenNewNoteView = true
    var isHiddenImportanceView = true
    var editorHightConstranint = 50 // 각 버튼에 맞는 editorView의 높이
    var editHightConstranint = 0 // 각 버튼에 맞는 editView의 높이
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
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            editorHightConstranint = 50
            editHightConstranint = 0
            navigationTitle = "메모"
            navigationItemRightTitle = "저장"
            
        case .write:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            navigationTitle = "수정"
            navigationItemRightTitle = "완료"
            
        case .trash:
            isHiddenEditView = true
            isHiddenTrashView = false
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            navigationTitle = "삭제"
            navigationItemRightTitle = "저장"
            
        case .background:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenBackGroundView = false
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            editorHightConstranint = 86
            editHightConstranint = 36
            navigationTitle = "배경 색상"
            navigationItemRightTitle = "완료"
            
        case .camera:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenBackGroundView = true
            isHiddenCameraView = false
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            navigationTitle = "사진 첨부"
            navigationItemRightTitle = "저장"
            
        case .textColor:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = false
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            editorHightConstranint = 201
            editHightConstranint = 151
            navigationTitle = "텍스트 색상"
            navigationItemRightTitle = "완료"
            
        case .newNote:
            isHiddenEditView = true
            isHiddenTrashView = true
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = false
            isHiddenImportanceView = true
            navigationTitle = "새 메모"
            navigationItemRightTitle = "저장"
            
        case .importance:
            isHiddenEditView = false
            isHiddenTrashView = true
            isHiddenBackGroundView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            isHiddenImportanceView = true
            editorHightConstranint = 86
            editHightConstranint = 36
            navigationTitle = "중요도"
            navigationItemRightTitle = "완료"
            
        }
    }
}
