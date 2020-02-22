//
//  NoteModel.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/21.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

class NoteModel
{
    var id: Int
    var title: String = ""
    var content: String = "내용 입력"
    var lastDate: String
    var importance: UIColor = .red
    
    init(id: Int, title:String, content: String, lastDate: String, importance: UIColor) {
        self.id = id
        self.title = title
        self.content = content
        self.lastDate = lastDate
        self.importance = importance
    }
    
}
