//
//  ImageModel.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/21.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

class ImageModel
{
    var id: Int = 0
    var note_id: Int = 0
    var photo: UIImage
    
    init(id: Int, note_id:Int, photo: UIImage) {
        self.id = id
        self.note_id = note_id
        self.photo = photo
    }
}
