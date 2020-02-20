//
//  NoteListableViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/17.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

class NoteListableViewController: UITableViewController {
    
    var db:DBHelper = DBHelper()
    var notes:[NoteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> App Loading Start")
        NSLog("---> Note List Start")
        
        self.setup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        db.insertNote(id: 0, title: "A 제목", conetent: "A 내용", lastDate: "2020/02/01", importance: .black)
        db.insertNote(id: 1, title: "B 제목", conetent: "B 내용", lastDate: "2020/02/03", importance: .red)
        db.insertNote(id: 2, title: "C 제목", conetent: "C 내용", lastDate: "2020/02/22", importance: .blue)
        
        notes = db.read()
    }
    
    private func setup(){
        self.setupNavigation()
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
    
    // 새로운 노트를 만드는 기능
    @IBAction func openNewNote(_ sender: Any){
        self.performSegue(withIdentifier: "showNoteViewController", sender: nil)
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
        cell.lblContents.text = note.conetent
        cell.lblLastModifiedDate.text = note.lastDate
        cell.impormationView.backgroundColor = note.importance
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showNoteViewController", sender: notes[indexPath.row])
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
