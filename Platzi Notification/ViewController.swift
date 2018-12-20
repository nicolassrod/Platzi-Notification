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

	private var dataCalendar: DataAgenda?

    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.AgendaTableView.delegate = self
        self.AgendaTableView.dataSource = self
        self.AgendaTableView.separatorColor = UIColor.clear

        addNavBarImage()
        getDataFromApi()
    }
	
    private func addNavBarImage() {
		guard let navController = navigationController else {
			return
		}
		
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "platzi"))
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height

        let bannerX = bannerWidth / 2 - #imageLiteral(resourceName: "platzi").size.width / 2
        let bannerY = bannerHeight / 2 - #imageLiteral(resourceName: "platzi").size.height / 2
        
        logoImageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        logoImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = logoImageView
    }

    func getDataFromApi() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20.0

        let session = URLSession(configuration: config)
        let url = URL(string: "https://platzi-agenda.herokuapp.com/get-agenda-data/")!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Conecction Error ", error!.localizedDescription)
                print(error?.localizedDescription as Any)
				
                let alert = UIAlertController(title: "Error 🤔", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.getDataFromApi()
                }))
				
                self.present(alert, animated: true, completion: nil)

                return
            }

            guard let data = data else {
				return
			}

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("No 200 status")
                do {
                    let url = URL(string: "https://platzi-agenda.herokuapp.com/set-agenda-data/")
                    URLSession.shared.dataTask(with: url!) {_,_,_ in
                        print("no 200 run")
					}.resume()
				}
				self.getDataFromApi()
            }

            do {
            	let jsonSerialized = try JSONDecoder().decode(DataAgenda.self, from: data)
            	self.dataCalendar = jsonSerialized
				self.addNewNotifications(whitData: jsonSerialized)
			} catch let DecodingError.dataCorrupted(context) {
				print(context)
			} catch let DecodingError.keyNotFound(key, context) {
				print("Key '\(key)' not found:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch let DecodingError.valueNotFound(value, context) {
				print("Value '\(value)' not found:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch let DecodingError.typeMismatch(type, context)  {
				print("Type '\(type)' mismatch:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch {
				print("error: ", error)
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
			
			guard let data = self.dataCalendar else {
				return
			}
			
            let content = UNMutableNotificationContent()
			content.title = data[i].details.title
            content.body = data[i].details.description
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default

            let formatted = DateFormatter()
            formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
            let date = formatted.date(from: data[i].startTime)
            if date!.timeIntervalSinceNow <= 0 {
                continue
            }

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date!.timeIntervalSinceNow, repeats: false)

            let request = UNNotificationRequest(
                identifier: "course.\(data[i].id)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                } else {
                    print("Added notification number \(i)")
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {

        case "ShowDetail":
            guard let detailViewController = segue.destination as? CourseViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let indexPath = AgendaTableView.indexPathForSelectedRow else {
                fatalError("The selected cell is not being displayed by the table")
            }
			
			guard let data = dataCalendar else {
				return
			}

            let selected = data[indexPath.row]
            print(selected.details.title)
            detailViewController.data = selected.details

        default:
            print("nil")
        }
    }


}

// MARK: - TableView
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataCalendar?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = AgendaTableView.dequeueReusableCell(withIdentifier: "AgendaCell") as? AgendaTableViewCell else {
			return UITableViewCell()
		}
		
		guard let dataCalendar = self.dataCalendar else {
			return UITableViewCell()
		}
		
		cell.EventNameLabel.text = dataCalendar[indexPath.row].details.title
        cell.EventImage.moa.url = dataCalendar[indexPath.row].details.badge

        let formatted = DateFormatter()
        formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let date = formatted.date(from: dataCalendar[indexPath.row].startTime)

        formatted.dateFormat = "HH:mm"
        let dateString = formatted.string(from: date!)

        cell.EventTimeLabel.text = "\(dateString)"

        return cell
    }

}

extension ViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//
//
//    }

}
