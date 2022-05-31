//
//  MovieListCell.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import UIKit

class MovieListCell: UITableViewCell {

    static let cellIdentifier = "MovieListCell"
    
    @IBOutlet weak var  posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptonLabel: UILabel!

    var eachCell:MovieListCellVM!{
        didSet {
            
            let placeholderImage = UIImage(named: "movie_PlaceHolder")
            
            self.titleLabel.text = eachCell.title
            self.descriptonLabel.text = eachCell.description
            guard let url = eachCell?.coverUrl else {
                return
            }
            posterImageView.getImage(url: url, placeholderImage:placeholderImage) { (success) in
            } failer: { [weak self] (faield) in
                self?.posterImageView.image = placeholderImage
            }

        }
    }


}
