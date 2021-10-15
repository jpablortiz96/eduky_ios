//
//  TableViewControllerVideos.swift
//  
//
//  Created by Juan Pablo Enriquez  on 7/07/19.
//
//

import UIKit
import Firebase

class cellWebVideo: UITableViewCell {
    
    @IBOutlet weak var videoWeb: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

class TableViewControllerVideos: UITableViewController, UISearchBarDelegate, UIWebViewDelegate {

    @IBOutlet weak var searchBarVideo: UISearchBar!
    
    
    var videoList:[Video]  = [Video]()
    var actualVideoList:[Video]  = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
          self.navigationItem.title = "Videos"
        
        videoList = [Video]()
        
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("Videos").child("Categoria").observe(.value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0 {
                
                self.videoList.removeAll()
                
                for videos in snapchot.children.allObjects as! [DataSnapshot]{
                
                    let videoObject = videos.value as? [String: AnyObject]
                    let videoNombre = videoObject?["nombreVideo"]
                    let urlNombre = videoObject?["urlVideo"]
                    
                    let video = Video(nombreVideo: videoNombre as! String, urlVideo: urlNombre as! String)
                    
                    self.videoList.append(video)
                    
                    self.actualVideoList = self.videoList.shuffled()
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
        return actualVideoList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellvideo", for: indexPath) as! cellWebVideo
        
        let eachVideo = actualVideoList[indexPath.row]
        
        cell.videoWeb.loadHTMLString(eachVideo.urlVideo, baseURL: nil)

        // Configure the cell...

        return cell
    }
    
    private func setUpSearchBar(){
        searchBarVideo.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        guard !searchText.isEmpty else {
            self.actualVideoList = self.videoList
            self.tableView.reloadData()
            return
        }
        
        actualVideoList = videoList.filter({ (video) -> Bool in
            video.nombreVideo.lowercased().contains(searchText.lowercased())
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



