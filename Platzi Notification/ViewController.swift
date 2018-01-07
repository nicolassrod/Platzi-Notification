//
//  ViewController.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 20/12/17.
//  Copyright © 2017 Nicolás Rodríguez. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var AgendaTableView: UITableView!

    var DataCalendar: DataAgenda!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.AgendaTableView.delegate = self
        self.AgendaTableView.dataSource = self
        self.AgendaTableView.separatorColor = UIColor.clear
        
        
        addNavBarImage()
        getDataFromApi()
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

    func getDataFromApi() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        let url = URL(string: "https://platzi-calendar-api-pjqzjebrnm.now.sh/get-agenda-data/")!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else { return }
           
            do {
                let jsonSerialized = try? JSONDecoder().decode( DataAgenda.self, from: data)
                self.DataCalendar = jsonSerialized!
            }
            DispatchQueue.main.async {
                self.AgendaTableView.reloadData()
            }
            
        }
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// MARK: - TableView
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataCalendar == nil ? 0 : self.DataCalendar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TabelView execute")
        let cell = AgendaTableView.dequeueReusableCell(withIdentifier: "AgendaCell") as! AgendaTableViewCell
        cell.EventNameLabel.text = self.DataCalendar[indexPath.row].details.title
        cell.EventImage.moa.url = self.DataCalendar[indexPath.row].details.badge
        
        if self.DataCalendar == nil {
            print("Data is nil")
        } else {
            let content = UNMutableNotificationContent()
            content.title = "🔴 \(self.DataCalendar[indexPath.row].details.title)"
            content.body = self.DataCalendar[indexPath.row].details.description
            
            let formatted = DateFormatter()
            formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
            formatted.date(from: self.DataCalendar[indexPath.row].startTime)
            
            var dateInfo = DateComponents()
			dateInfo.calendar = formatted.calendar
            dateInfo.timeZone = formatted.timeZone

            let triger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
			let request = UNNotificationRequest(identifier: "\(self.DataCalendar[indexPath.row].id)", content: content, trigger: triger)

			let center = UNUserNotificationCenter.current()
//			center.add(<#T##request: UNNotificationRequest##UNNotificationRequest#>, withCompletionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
        }
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
