//
//  TabBarViewController.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 21/07/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarItems()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setTabBarItems(){
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "outline_cast_connected_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "outline_cast_for_education_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.title = "Educadores"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "outline_video_library_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "twotone_video_library_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.title = "Videos"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "outline_headset_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "twotone_headset_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem3.title = "Audio Libros"
        myTabBarItem3.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "outline_book_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "twotone_book_black_18dp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem4.title = "Ebook"
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
    }

}
