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

    override func viewDidAppear(_ animated: Bool) {

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
        config.timeoutIntervalForRequest = 20.0

        let session = URLSession(configuration: config)
        let url = URL(string: "https://platzi-calendar-api-pjqzjebrnm.now.sh/get-agenda-data/")!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Conecction Error")
                print(error?.localizedDescription as Any)
                let alert = UIAlertController(title: "Error 🤔", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.getDataFromApi()
                }))
                self.present(alert, animated: true, completion: nil)

                return
            }

            guard let data = data else { return }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("No 200 status")
                do {
                    let url = URL(string: "https://platzi-calendar-api-pjqzjebrnm.now.sh/set-agenda-data/")
                    let task = URLSession.shared.dataTask(with: url!) {_,_,_ in
                        print("no 200 run")
                    }

                    task.resume()
                }
                self.getDataFromApi()
            }

            do {
                print(data)
                let jsonSerialized = try JSONDecoder().decode(DataAgenda.self, from: data)
                self.DataCalendar = jsonSerialized
                self.addNewNotifications(whitData: self.DataCalendar)
            } catch {
//                self.AgendaTableView.backgroundColor = .black
            }
            DispatchQueue.main.async {
                self.AgendaTableView.reloadData()
            }
            
        }
        task.resume()
        
    }

    func addNewNotifications(whitData dataJson: DataAgenda) {

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        for i in 0..<dataJson.count {

            let content = UNMutableNotificationContent()
            content.title = "\(self.DataCalendar[i].details.title)"
            content.body = self.DataCalendar[i].details.description
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default()

            let formatted = DateFormatter()
            formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
            let date = formatted.date(from: self.DataCalendar[i].startTime)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date!.timeIntervalSinceNow, repeats: false)

            let request = UNNotificationRequest(
                identifier: "course.\(self.DataCalendar[i].id)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                } else {
                    print("added")
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])

        /* Not a very good way to do this, just here to give you ideas.
         let alert = UIAlertController(
         title: notification.request.content.title,
         message: notification.request.content.body,
         preferredStyle: .alert)
         let okAction = UIAlertAction(
         title: "OK",
         style: .default,
         handler: nil)
         alert.addAction(okAction)
         present(alert, animated: true, completion: nil)
         */
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
        let cell = AgendaTableView.dequeueReusableCell(withIdentifier: "AgendaCell") as! AgendaTableViewCell
        cell.EventNameLabel.text = self.DataCalendar[indexPath.row].details.title
        cell.EventImage.moa.url = self.DataCalendar[indexPath.row].details.badge

        let formatted = DateFormatter()
        formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let date = formatted.date(from: self.DataCalendar[indexPath.row].startTime)

        formatted.dateFormat = "HH:mm"
        let dateString = formatted.string(from: date!)

        cell.EventTimeLabel.text = "\(dateString)"

        return cell
    }

}

extension ViewController: UITableViewDelegate {
    
}
