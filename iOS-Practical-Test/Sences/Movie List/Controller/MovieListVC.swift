//
//  MovieListVC.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//
import UIKit

class MovieListVC: UIViewController {
    
    public var coordinator: MovieListCoordinator?
    
    @IBOutlet weak var movieListTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
