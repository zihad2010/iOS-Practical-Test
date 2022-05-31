//
//  MovieListCell.swift
//  iOS-Practical-Test
//
//  Created by Maya on 1/6/22.
//

import UIKit

import UIKit

class MovieListCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        containerView.addSubview(posterImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate(staticConstraints())
    }
    
    //MARK: - Elements -
    
    private let posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var eachCell:MovieListCellVM! {
       
        didSet {
        
            self.titleLabel.text = eachCell.title
            self.descriptionLabel.text = eachCell.description
            
            guard let url = eachCell?.coverUrl else {
                return
            }
            
            let placeholderImage = UIImage(named: "movie_PlaceHolder")
            self.posterImageView.getImage(url: url, placeholderImage:placeholderImage) { (success) in
            } failer: { [weak self] (faield) in
                self?.posterImageView.image = placeholderImage
            }
        }
    }
}

// MARK: - set Constant -

extension MovieListCell {
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.heightAnchor.constraint(equalToConstant: 128.0),
            posterImageView.widthAnchor.constraint(equalToConstant: 90.0),
            posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        constraints.append(contentsOf: [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            containerView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: posterImageView.heightAnchor)
        ])
        
        constraints.append(contentsOf: [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        constraints.append(contentsOf: [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant:10.0),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: 0.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return constraints
    }
}
