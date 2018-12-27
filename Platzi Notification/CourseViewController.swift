//
//  CourseViewController.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 19/01/18.
//  Copyright © 2018 Nicolás Rodríguez. All rights reserved.
//

import UIKit
import SafariServices

class CourseViewController: UIViewController {

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
	
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseDescription: UILabel!
    @IBOutlet weak var backImage: UIImageView!
	@IBOutlet weak var videButton: UIButton!
	@IBOutlet weak var eventDate: UILabel!
	
    var data: DataAgendum?

    override func viewDidLoad() {
        super.viewDidLoad()
		
        courseTitle.text = data?.details.title
        courseDescription.text = data?.details.description
        image.moa.url = data?.details.badge
        backImage.moa.url = data?.details.socialImageURL
		data?.details.video == nil ? (videButton.isHidden = true) : (videButton.isHidden = false)
		
		let formatted = DateFormatter()
		formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
		let date = formatted.date(from: data!.startTime)
		
		formatted.locale = Locale.current
		formatted.dateFormat = "MMMM d - h:mm a"
		let dateString = formatted.string(from: date ?? Date())
		eventDate.text = dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButton(_ sender: Any) {
		guard let data = data else {
			return
		}
		
		guard let url = URL(string: "https://platzi.com\(data.details.url)") else {
			return
		}
		
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = UIColor(named: "Type")
        safariVC.preferredControlTintColor = UIColor(named: "Primary")

        present(safariVC, animated: true, completion: nil)
    }

	@IBAction func videoButton(_ sender: UIButton) {
		guard let data = data else {
			return
		}
		
		guard let url = URL(string: "http://youtube.com/watch?v=\(data.details.video ?? "NKtTJi8Bp6I")") else {
			return
		}
		
		let safariVC = SFSafariViewController(url: url)
		safariVC.preferredBarTintColor = UIColor(named: "Type")
		safariVC.preferredControlTintColor = UIColor(named: "Primary")
		
		present(safariVC, animated: true, completion: nil)
	}
}
