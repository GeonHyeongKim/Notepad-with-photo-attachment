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
    var id: Int = 0
    var title: String = ""
    var content: String = "내용 입력"
    var lastDate: String
    var importance: UIColor = .white
    var background: UIColor = .black
    var textSize: Int = 14
    var textColor: UIColor = .white
    
    init(id: Int, title:String, content: String, lastDate: String, importance: UIColor, background: UIColor, text_size: Int, text_color: UIColor) {
        self.id = id
        self.title = title
        self.content = content
        self.lastDate = lastDate
        self.importance = importance
        self.background = background
        self.textSize = text_size
        self.textColor = text_color
    }
}
