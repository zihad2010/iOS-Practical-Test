//
//  MovieListVC.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//
import UIKit
import RxSwift
import RxCocoa
import Reachability
import RxReachability

class MovieListVC: UIViewController {
    
    @IBOutlet weak var navBar: UIView!
    
   //MARK: Elements
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.returnKeyType = .done
        searchBar.placeholder = " Search Here....."
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var movieListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
                tableView.register(MovieListCell.self,
                           forCellReuseIdentifier: MovieListCell.reuseIdentifier)
        return tableView
    }()

    private let activity = ActivityIndicator()
    private let disposable = DisposeBag()
    private let reachability: Reachability! = try? Reachability()
    public var coordinator: MovieListCoordinator?
    private let movieListVM = MovieListVM()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        searchBarBinding()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupView() {
        
        view.addSubview(searchBar)
        view.addSubview(movieListTableView)
        self.hideKeyboardWhenTappedonView()
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    private func setupBindings(){
        
        reachability?.rx.isReachable
            .subscribe(onNext: { [weak self] isReachable in
                isReachable ? self?.fetchDataFromApi() : ToastView.shared.short(self?.view, txt_msg: "Please check your internet!")
            })
            .disposed(by: disposable)
        
        movieListVM
            .loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.activity.showLoading(view: self?.view) : self?.activity.hideLoading()
            })
            .disposed(by: disposable)

        movieListVM
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                ToastView.shared.short(self?.view, txt_msg: "  \(error)  ")
            })
            .disposed(by: disposable)
        
        self.tableViewBinding()
        self.searchBarBinding()
    }
}

//MARK: -  search movie with default text-

extension MovieListVC {
    
    fileprivate func fetchDataFromApi() {
        movieListVM.getDataWith(resource: movieListVM.createResource() as! Resource<MovieListModel.Response>)
    }
}

//MARK: - show movie list && bindto tableview -

extension MovieListVC {
    
    fileprivate func tableViewBinding() {
        
        movieListVM
            .movieList
            .observeOn(MainScheduler.instance)
            .bind(to: movieListTableView.rx.items(cellIdentifier: MovieListCell.reuseIdentifier, cellType: MovieListCell.self)) {  (row,vm,cell) in
                cell.eachCell = vm
            }
            .disposed(by: disposable)
    }
}

//MARK: - search movie func. implementation -

extension MovieListVC {
    
    fileprivate func searchBarBinding() {
        
        searchBar
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: self.movieListVM.searchText)
            .disposed(by: disposable)
        
        self.movieListVM
            .searchText
            .subscribe(onNext: { [weak self] text in
                text.isEmpty ? self?.fetchDataFromApi() :
                self?.movieListVM.getDataWith(resource: self?.movieListVM.createResource(text:text) as! Resource<MovieListModel.Response>)
            })
            .disposed(by: disposable)
        
        self.searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [unowned self] in
                searchBar.resignFirstResponder()
            })
            .disposed(by: disposable)
        
        self.searchBar
            .rx
            .searchButtonClicked
            .subscribe(onNext: { [unowned self] in
                searchBar.resignFirstResponder()
            })
            .disposed(by: disposable)

    }
}

//MARK: - set Elements constant -

extension MovieListVC {
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            searchBar.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        constraints.append(contentsOf: [
            movieListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant:0),
            movieListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return constraints
    }
        
}
