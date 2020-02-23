//
//  NoteListableViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/17.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

var notes:[NoteModel] = []

class NoteListableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> App Loading Start")
        NSLog("---> Note List Start")
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notes = db.read()
        self.tableView.reloadData()
    }
    
    private func setup(){
//        db.insertNote(id: 0, title: "A 제목", content: "A 내용", lastDate: "2020/02/01", importance: .white, background: .black)
//        db.insertNote(id: 1, title: "B 제목", content: "B 내용", lastDate: "2020/02/03", importance: .red)
//        db.insertNote(id: 2, title: "C 제목", content: "C 내용", lastDate: "2020/02/22", importance: .blue)
//        self.setupNavigation()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showNoteViewController"){
            if sender != nil {
                let noteViewController = segue.destination as? NoteViewController
                noteViewController?.note = sender as? NoteModel
            }
        }
    }
    
    // 현재 날짜
    func currentDate() -> String{
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: now as Date)
    }
    
    // 새로운 노트를 만드는 기능
    @IBAction func openNewNote(_ sender: Any){
        let note = NoteModel(id: 0, title: "", content: "내용 입력", lastDate: currentDate(), importance: .white, background: .black)
        notes.append(note)
        db.insertNote(id: note.id, title: note.title, content: note.content, lastDate: note.lastDate, importance: note.importance, background: note.background)
        note.id = db.readLast().id
        self.performSegue(withIdentifier: "showNoteViewController", sender: note)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCnt = notes.count
        return rowCnt
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        
        let note = notes[indexPath.row]
        
        cell.lblTitle.text = note.title
        cell.lblContents.text = note.content
        cell.lblLastModifiedDate.text = note.lastDate
        cell.impormationView.backgroundColor = note.importance
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showNoteViewController", sender: notes[indexPath.row])
    }
}
