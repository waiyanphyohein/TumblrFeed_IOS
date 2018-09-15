import UIKit
import AlamofireImage
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // An array of Dictionaries to store data from network requests
    var posts: [[String: Any]] = []
    
    var postURLLink: String!;
    var imageDescriptionDisplay: String!;
    var slug: String!;
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = self.posts[indexPath.row]
        let summary = post["summary"] as! String
        let slug = post["slug"] as! String
        
        imageDescriptionDisplay = post["caption"] as! String
        let photos = post["photos"] as! [[String: Any]]
        let photo = photos[0]
        
        //High Resoluation Images Parser
        let originalImage = photo["original_size"] as! [String: Any]
        let postURL = originalImage["url"] as! String
        
        //Low Resolution Images Parser.
        let altImage = photo["alt_sizes"] as! [[String: Any]]
        let lowResURL = altImage[4]
        let postLowURL = lowResURL["url"] as! String
        
        self.postURLLink = postURL;
        self.slug = slug
        let smallImageRequest = URLRequest(url: URL(string: postLowURL)!)
        let largeImageRequest = URLRequest(url: URL(string: postURL)!)
        
        cell.photoDescription.text = summary
//        cell.postImages.setImageWith(URL(string: postLowURL)!)
        cell.postImages.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.postImages.alpha = 0.0
                cell.postImages.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    cell.postImages.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    cell.postImages.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            cell.postImages.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = tableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let detailViewController = segue.destination as! DetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        detailViewController.index = index
        detailViewController.imageDescriptionDisplay = self.imageDescriptionDisplay
        detailViewController.postURLLink = self.postURLLink
        detailViewController.titleSection = self.slug
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

