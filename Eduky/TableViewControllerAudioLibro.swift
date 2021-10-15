//
//  TableViewControllerAudioLibro.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 13/07/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit
import Firebase

class cellAudioLibro: UITableViewCell {
    
    @IBOutlet weak var cellAudioLibro: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class TableViewControllerAudioLibro: UITableViewController, UISearchBarDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var searchBarAudioLibro: UISearchBar!
    
    var audioLibroList:[AudioLibro]  = [AudioLibro]()
    var actualAudioLibroList:[AudioLibro]  = [AudioLibro]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Audio Libros"
        
        audioLibroList = [AudioLibro]()
        
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("Audiolibros").child("Tipo").observe(.value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0 {
                
                self.audioLibroList.removeAll()
                
                for audiolibros in snapchot.children.allObjects as! [DataSnapshot]{
                    
                    let audioLibroObject = audiolibros.value as? [String: AnyObject]
                    let audioLibroNombre = audioLibroObject?["nombreAL"]
                    let urlNombre = audioLibroObject?["urlAL"]
                    
                    let audiolibro = AudioLibro(nombreAL: audioLibroNombre as! String, urlAL: urlNombre as! String)
                    
                    self.audioLibroList.append(audiolibro)
                    
                    self.actualAudioLibroList = self.audioLibroList.shuffled()
                    
                }
            }
            
            self.tableView.reloadData()
            
            
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actualAudioLibroList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAudioLibro", for: indexPath) as! cellAudioLibro
        
        let eachAudioLibro = actualAudioLibroList[indexPath.row]
        
        cell.cellAudioLibro.loadHTMLString(eachAudioLibro.urlAL, baseURL: nil)
        
        // Configure the cell...

        return cell
    }
    
    private func setUpSearchBar(){
        searchBarAudioLibro.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        guard !searchText.isEmpty else {
            self.actualAudioLibroList = self.audioLibroList
            self.tableView.reloadData()
            return
        }
        
        actualAudioLibroList = audioLibroList.filter({ (audiolibro) -> Bool in
            audiolibro.nombreAL.lowercased().contains(searchText.lowercased())
        }).shuffled()
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



