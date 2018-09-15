import UIKit
import AlamofireImage

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // An array of Dictionaries to store data from network requests
    var posts: [[String: Any]] = []
    
    // Global refresh control attribute for other functions to access
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AFNetworking extension to UIImageView that allows
        // specifying a URL for the image
        // Swift 3 should use URL instead of NSURL
        

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchPhotos()
        
    }
    
    func fetchPhotos() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary);
                
                // Get posts and store in posts property
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                // Reload table view after network request data returns
                self.tableView.reloadData()
                
                // Stops refreshControl from spinning 1 second after data returns
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.refreshControl.endRefreshing()
                //})
            }
        }
        task.resume()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPhotos()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell;
        let myImageUrlString = ("https://i.imgur.com/tGbaZCY.jpg") as String
        let URLImage = URL(string:myImageUrlString)!
        cell.photoDescription.text = "This is row \(indexPath.row)"
        cell.postImages.af_setImage(withURL: URLImage)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

