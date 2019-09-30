//
//  ArticleViewController.swift
//  LiteNews
//
//  Created by Thanh Nguyen on 9/27/19.
//  Copyright © 2019 Thanh Nguyen. All rights reserved.
//
import UIKit
import AlamofireImage

class ArticleViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var ivArticle: UIImageView!
    
    // MARK: - Properties
    
    public var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = selectedArticle?.title
        tvContent.text = selectedArticle?.content
        
        if let imgStr = selectedArticle?.urlToImage, let url = URL(string: imgStr) {
            ivArticle.af_setImage(withURL: url)
        } else {
            ivArticle.isHidden = true
        }
    }
}
