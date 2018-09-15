//
//  DetailViewController.swift
//  Tumblr_Feed_Project_IOS
//
//  Created by WaiYanPhyo Hein on 9/13/18.
//  Copyright © 2018 WaiYanPhyo Hein. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var captionTitle: UINavigationItem!
    var titleSection: String!
    var index: Int!
    var postURLLink: String!
    var imageDescriptionDisplay: String!
    @IBOutlet weak var photoDescription: UILabel!
    @IBOutlet weak var imageDisplay: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageDisplay.setImageWith(URL(string: postURLLink)!)
        let removeP = imageDescriptionDisplay.replacingOccurrences(of: "<p>", with: "")
        let removeSP = removeP.replacingOccurrences(of: "</p>", with: "")
        self.photoDescription.text = removeSP.replacingOccurrences(of: "<br/>", with: "\n")
        captionTitle.title = (self.titleSection.replacingOccurrences(of: "-", with: " "))
        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
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
