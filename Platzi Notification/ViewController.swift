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
	private var refreshControl = UIRefreshControl()
	private var searchController = UISearchController(searchResultsController: nil)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		AgendaTableView.delegate = self
        AgendaTableView.dataSource = self
		AgendaTableView.addSubview(refreshControl)
		
		refreshControl.addTarget(self, action: #selector(getDataRefreshValueChanged(_:)), for: .valueChanged)
		
		searchController.searchResultsUpdater = self
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.barStyle = .black
		searchController.searchBar.tintColor = UIColor(named: "Primary")
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.dimsBackgroundDuringPresentation = false
		
		definesPresentationContext = true
		
		navigationItem.searchController = searchController
		
        addNavBarImage()
		
		Network().getDataFromApi() { [weak self] dataSerialized, error in
			guard let `self` = self else {
				return
			}
			
			guard error == nil else {
				print("Conecction Error ", error?.localizedDescription as Any)
				print(error?.localizedDescription as Any)

				let alert = UIAlertController(title: "Error 🤔", message: error?.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

				self.present(alert, animated: true, completion: nil)
				return
			}
			
			guard let data = dataSerialized else {
				return
			}
			
			self.dataCalendar = data
			self.addNewNotifications(whitData: data)
			
			DispatchQueue.main.async {
				self.AgendaTableView.reloadData()
			}
		}
    }
	
    private func addNavBarImage() {
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "platzi"))
		logoImageView.contentMode = .scaleAspectFit
		
        navigationItem.titleView = logoImageView
    }

	@objc func getDataRefreshValueChanged(_ sender: Any) {
		Network().getDataFromApi() { [weak self] dataSerialized, error in
			guard let `self` = self else {
				return
			}
			
			guard error == nil else {
				print("Conecction Error ", error?.localizedDescription as Any)
				print(error?.localizedDescription as Any)
				
				let alert = UIAlertController(title: "Error 🤔", message: error?.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default,  handler: nil))
				
				self.present(alert, animated: true, completion: {
					DispatchQueue.main.async {
						self.refreshControl.endRefreshing()
					}
				})
				
				return
			}
			
			guard let data = dataSerialized else {
				return
			}
			
			self.dataCalendar = data
			self.addNewNotifications(whitData: data)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
				self.AgendaTableView.reloadData()
				self.refreshControl.endRefreshing()
			})
		}
	}

    func addNewNotifications(whitData dataJson: DataAgenda) {

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        for i in 0..<dataJson.count {
			
            let content = UNMutableNotificationContent()
			content.title = dataJson[i].details.title
            content.body = dataJson[i].details.description
            content.categoryIdentifier = "message"
            content.sound = UNNotificationSound.default

            let formatted = DateFormatter()
            formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
            let date = formatted.date(from: dataJson[i].startTime)
			
			guard let _data = date, _data.timeIntervalSinceNow >= 0 else {
				continue
			}
			
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: _data.timeIntervalSinceNow, repeats: false)

            let request = UNNotificationRequest(
                identifier: "course.\(dataJson[i].id)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { (error: Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                } else {
                    print("Added notification number \(i)")
                }
            }
        }
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

            let _data = data[indexPath.row]
            print(_data.details.title)
            detailViewController.data = _data

        default:
            print("nil")
        }
    }


}

// MARK: - TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {

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
		cell.EventDescriptiion.text = dataCalendar[indexPath.row].details.socialDescription
        cell.EventImage.moa.url = dataCalendar[indexPath.row].details.badge
		
		cell.agendaItemType(type: dataCalendar[indexPath.row].agendaItemType)
		
        let formatted = DateFormatter()
        formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let date = formatted.date(from: dataCalendar[indexPath.row].startTime)

        formatted.dateFormat = "MMM d"
        let dateString = formatted.string(from: date ?? Date())

        cell.EventTimeLabel.text = "\(dateString)"

        return cell
    }

}

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		print(searchController.searchBar.text)
	}
	
	
}
