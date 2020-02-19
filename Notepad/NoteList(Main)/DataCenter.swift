//
//  DataCenter.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/17.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

let dataCenter: DataCenter = DataCenter()

class DataCenter {
    var noteList: [Note] = []
    
    init() {
        let title1 = Note(title: "A 메모", conetent: "A내용", lastDate: "2020/02/01", importance: .red)
        let title2 = Note(title: "B 메모", conetent: "B내용", lastDate: "2020/02/22", importance: .blue)
        
        noteList.append(title1)
        noteList.append(title2)
    }
}

class Note {
    var title: String
    var conetent: String
    var lastDate: String
    var importance: UIColor
    
    init(title:String, conetent: String, lastDate: String, importance: UIColor) {
        self.title = title
        self.conetent = conetent
        self.lastDate = lastDate
        self.importance = importance
    }
}
