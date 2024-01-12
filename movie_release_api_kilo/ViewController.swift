//
//  ViewController.swift
//  movie_release_api_kilo
//
//  Created by Miles Richmond on 1/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ghost_date: UILabel!
    @IBOutlet weak var user_in: UITextField!
    @IBOutlet weak var user_date: UILabel!
    
    var result: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let _ = getDate(name: "Ghost", true)
    }

    func getDate(name: String, _ isInit: Bool) -> String {
        let session = URLSession.shared
        
        let url = URL(string: "http://www.omdbapi.com/?t=\(name)&apikey=4bcb7cf5")!
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                self.result = "\(err)"
                print("ERR: \(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        if let year = json.value(forKey: "Year") as? String {
                            self.result = year
                        } else if let err = json.value(forKey: "Error") as? String {
                            self.result = err
                        }
                    }
                }
            }
        }
        
        dataTask.resume()
        
        if(isInit) {
            DispatchQueue.main.async {
                self.ghost_date.text = self.result
                self.result = ""
            }
        }
        
        return result
    }
    
    @IBAction func search_action(_ sender: UIButton) {
        user_date.text = "Release Date: \(getDate(name: user_in.text!, false))"
    }
}

