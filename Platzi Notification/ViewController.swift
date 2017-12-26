//
//  ViewController.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 20/12/17.
//  Copyright © 2017 Nicolás Rodríguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var AgendaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.AgendaTableView.delegate = self
        self.AgendaTableView.dataSource = self
        self.AgendaTableView.separatorColor = UIColor.clear
        
        addNavBarImage()
        
    }
    
    func addNavBarImage() {
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "platzi")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// MARK: -
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgendaTableView.dequeueReusableCell(withIdentifier: "AgendaCell") as! AgendaTableViewCell
//        cell.EventNameLabel.text = "asdasdasd"
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
