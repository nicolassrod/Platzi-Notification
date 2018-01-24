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

    var data: Details?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ooooooo")

        courseTitle.text = data?.title
        courseDescription.text = data?.socialDescription
        image.moa.url = data?.badge
        backImage.moa.url = data?.socialImageURL
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButton(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: "https://platzi.com\(String(describing: data!.url))")!)
        safariVC.preferredBarTintColor = UIColor(named: "Type")
        safariVC.preferredControlTintColor = UIColor(named: "Primary")

        self.present(safariVC, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
