//
//  ViewController.swift
//  LiteNews
//
//  Created by Thanh Nguyen on 9/26/19.
//  Copyright © 2019 Thanh Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TopHeadlineViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    // MARK: - Properties
    private var articles = [Article]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTopHeadlineRequest() { (responseModel) in
            self.articles = responseModel?.articles ?? [Article]()
        }
        
    }
        
    func getTopHeadlineRequest(completion: @escaping (ResponseModel?) -> Void) {
        
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=67a45fda74af4ca5847f43e6940c792e"
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


extension TopHeadlineViewController: UITableViewDataSource {
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

extension TopHeadlineViewController: UITableViewDelegate {
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

enum TableStateString {
    case Empty
    case Loading
    case Failed
    case Items([String])
    
    var count: Int {
        switch self {
        case let .Items(items):
            return items.count
        default:
            return 1
        }
    }
    
    func value(row: Int) -> String {
        switch self {
        case .Loading:
            return "Loading..."
        case .Failed:
            return "Failed"
        case .Empty:
            return "Empty"
        case let .Items(items):
            let item = items[row]
            return item
        }
    }
}

