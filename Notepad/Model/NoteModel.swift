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
    var title: String
    var conetent: String
    var lastDate: String
    var importance: UIColor
    
    init(id: Int, title:String, conetent: String, lastDate: String, importance: UIColor) {
        self.id = id
        self.title = title
        self.conetent = conetent
        self.lastDate = lastDate
        self.importance = importance
    }
    
}
