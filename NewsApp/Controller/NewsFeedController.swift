//
//  ViewController.swift
//  NewsApp
//
//  Created by Gytis Ptašinskas on 21/11/2023.
//

import UIKit
import SDWebImage

class NewsFeedController: UITableViewController {
    
    private var cellID = "cell"
    private var newsItems:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getNewsData()
    }
    
    private func setupView(){
        title = "News"
        view.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: cellID)
        tableView.rowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor:UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func getNewsData(){
        NetworkManager.fetchData(url: NetworkManager.api){
            newsItems in
            self.newsItems = newsItems.articles ?? []
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
}

extension NewsFeedController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = newsItems[indexPath.row]
        let detailsViewController = ArticleDetails()
        detailsViewController.configure(with: article)
        navigationController?.pushViewController(detailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        
        let article = self.newsItems[indexPath.row]
        
        let titleLabel = UILabel()
        titleLabel.text = article.title ?? ""
        
        let widthTitleConstr = NSLayoutConstraint(item: titleLabel,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                                  toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 175)
        
        titleLabel.addConstraint(widthTitleConstr)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string:article.urlToImage ?? ""))
        
        let widthImageConstr = NSLayoutConstraint(item: imageView,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 165)
        
        let heightImageConstr = NSLayoutConstraint(item: imageView,
                                                   attribute: NSLayoutConstraint.Attribute.height,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 150)
        
        imageView.addConstraints([widthImageConstr,heightImageConstr])
        
        let stackView = UIStackView(arrangedSubviews: [imageView,titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        cell.addSubview(stackView)
        
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }
}

