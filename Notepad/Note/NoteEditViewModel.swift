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
    
    var isHiddenWriteView = true
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
            isHiddenWriteView = false
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = ""
            
        case .trash:
            isHiddenWriteView = true
            isHiddenTrashView = false
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = ""
            
        case .importance:
            isHiddenWriteView = true
            isHiddenTrashView = true
            isHiddenImportanceView = false
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = ""
            
        case .camera:
            isHiddenWriteView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = false
            isHiddenTextColorView = true
            isHiddenNewNoteView = true
            navigationTitle = ""
            
        case .textColor:
            isHiddenWriteView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = false
            isHiddenNewNoteView = true
            navigationTitle = ""
            
        case .newNote:
            isHiddenWriteView = true
            isHiddenTrashView = true
            isHiddenImportanceView = true
            isHiddenCameraView = true
            isHiddenTextColorView = true
            isHiddenNewNoteView = false
            navigationTitle = ""
        }
    }
}
