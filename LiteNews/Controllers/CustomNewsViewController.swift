//
//  CustomNewsViewController.swift
//  LiteNews
//
//  Created by Thanh Nguyen on 9/26/19.
//  Copyright © 2019 Thanh Nguyen. All rights reserved.
//

import UIKit
import TagListView
import Alamofire
import AlamofireImage

class  CustomNewsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tlvTags: TagListView!
    @IBOutlet weak var vTag: UIView!
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var bbiUpdate: UIBarButtonItem!
    
    // MARK: - Properties
    let tags = ["bitcoin", "apple", "earthquake", "animal"]
    
    private var articles = [Article]() {
        didSet {
            tableView.reloadData()
            vTag.isHidden = true
            tableView.isHidden = false
            bbiUpdate.isEnabled = true
        }
    }
    private var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tlvTags.textFont = UIFont.systemFont(ofSize: 17)
        tlvTags.addTags(tags)
        vTag.isHidden = false
        tableView.isHidden = true
        bbiUpdate.isEnabled = false
    }
    
    @IBAction func onClickUpdate(_ sender: UIBarButtonItem) {
        vTag.isHidden = false
        tableView.isHidden = true
        bbiUpdate.isEnabled = false
    }
    
    func getRequest(_ title: String, completion: @escaping (ResponseModel?) -> Void) {
        
        let url = "https://newsapi.org/v2/everything?q=\(title)&apiKey=67a45fda74af4ca5847f43e6940c792e"
        Alamofire.request(url).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(ResponseModel.self, from: data)
                completion(responseModel)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
}

extension CustomNewsViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        self.title = title.capitalized
        getRequest(title) { (responseModel) in
            self.articles = responseModel?.articles ?? [Article]()
        }
    }
}

extension CustomNewsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ArticleCell") as! ArticleCell
        let article = articles[indexPath.row]
        cell.lblTitle.text = article.title
        cell.lblDescription.text = article.description
        
        //displaying image
        if let imgStr = article.urlToImage, let url = URL(string: imgStr) {
            cell.ivArticle.af_setImage(withURL: url)
        }
        
        return cell
    }
}

extension CustomNewsViewController: UITableViewDelegate {
    // 1
    public func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedArticle = articles[indexPath.row]
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func prepare(for segue: UIStoryboardSegue,
                                 sender: Any?) {
        guard let viewController = segue.destination
            as? ArticleViewController else { return }
        viewController.selectedArticle = selectedArticle
    }
}


