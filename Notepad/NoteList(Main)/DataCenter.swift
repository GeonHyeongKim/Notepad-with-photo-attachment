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
        let title1 = Note(title: "A 메모")
        let title2 = Note(title: "B 메모")
        
        noteList.append(title1)
        noteList.append(title2)
    }
}

class Note {
    let title: String
    
    init(title:String) {
        self.title = title
    }
}
