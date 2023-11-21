//
//  ArticleDetails.swift
//  NewsApp
//
//  Created by Gytis Ptašinskas on 21/11/2023.
//

import UIKit

class ArticleDetails: UIViewController {
    
    var article: Article? {
        didSet {
            updateUI()
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let contentLabel = UILabel()
    private let publishedAtLabel = UILabel()
    private let readArticleButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        configureNavigationBar()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    } ()
    
    private func formattedDate(date: Date) -> String {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMMM dd, yyyy"
        return displayFormatter.string(from: date)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        titleLabel.numberOfLines = 0
        authorLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        contentLabel.numberOfLines = 0
        publishedAtLabel.numberOfLines = 0
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func layoutViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        publishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure authorDateStackView
        let authorDateStackView = UIStackView(arrangedSubviews: [authorLabel, UIView(), publishedAtLabel])
        authorDateStackView.axis = .horizontal
        authorDateStackView.distribution = .equalSpacing
        authorDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Container views for padding
        let titleContainerView = UIView()
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addSubview(titleLabel)
        
        let authorDateContainerView = UIView()
        authorDateContainerView.translatesAutoresizingMaskIntoConstraints = false
        authorDateContainerView.addSubview(authorDateStackView)
        
        let contentContainerView = UIView()
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.addSubview(contentLabel)
        
        // Button container view
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        setupReadArticleButton(containerView: buttonContainerView)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleContainerView, authorDateContainerView, contentContainerView, buttonContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Full width image
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Padding constraints for titleLabel, authorDateStackView, and contentLabel
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            authorDateStackView.leadingAnchor.constraint(equalTo: authorDateContainerView.leadingAnchor, constant: 16),
            authorDateStackView.trailingAnchor.constraint(equalTo: authorDateContainerView.trailingAnchor, constant: -16),
            authorDateStackView.topAnchor.constraint(equalTo: authorDateContainerView.topAnchor),
            authorDateStackView.bottomAnchor.constraint(equalTo: authorDateContainerView.bottomAnchor),
            
            contentLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -16),
            contentLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            
            // Stack View
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            // Image Height
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }





    private func updateUI() {
        guard let article = article else { return }
        
        // Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = article.title
        
        // Author
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.text = article.author
        
        // Date
        publishedAtLabel.font = UIFont.systemFont(ofSize: 14)
        if let dateString = article.publishedAt, let date = dateFormatter.date(from: dateString) {
            publishedAtLabel.text = formattedDate(date: date)
        }
        
        // Content
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.text = article.content
        contentLabel.numberOfLines = 0
        
        // Image
        if let imageUrlString = article.urlToImage, let url = URL(string: imageUrlString) {
            imageView.sd_setImage(with: url)
        }
    }

    private func setupReadArticleButton(containerView: UIView) {
        readArticleButton.setTitle("Read full article here", for: .normal)
        readArticleButton.backgroundColor = .black
        readArticleButton.setTitleColor(.white, for: .normal)
        readArticleButton.layer.cornerRadius = 10
        readArticleButton.clipsToBounds = true
        
        readArticleButton.translatesAutoresizingMaskIntoConstraints = false
        readArticleButton.addTarget(self, action: #selector(readArticleButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(readArticleButton)
        
        // Button constraints within its container
        NSLayoutConstraint.activate([
            readArticleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            readArticleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            readArticleButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            readArticleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            readArticleButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    
    @objc private func readArticleButtonTapped() {
        guard let urlString = article?.url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Article Details"
    }
    
    func configure(with article: Article) {
        self.article = article
    }
}
