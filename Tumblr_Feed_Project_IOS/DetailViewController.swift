//
//  DetailViewController.swift
//  Tumblr_Feed_Project_IOS
//
//  Created by WaiYanPhyo Hein on 9/13/18.
//  Copyright © 2018 WaiYanPhyo Hein. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var index: Int!

    @IBOutlet weak var photoDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoDescription.text = ("You tapped the cell at index \(index)")

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

}
