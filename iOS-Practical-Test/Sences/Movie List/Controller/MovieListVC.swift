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
    
    @IBOutlet weak var movieListTableView: UITableView!
    
    // MARK: - local storage
    
    private let disposable = DisposeBag()
    private let reachability: Reachability! = try? Reachability()
    public var coordinator: MovieListCoordinator?
    private let movieListVM = MovieListVM()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
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
    
    fileprivate func setupView(){
        self.hideKeyboardWhenTappedonView()
    }
    
    fileprivate func fetchDataFromApi() {
        movieListVM.getDataWith(resource: movieListVM.createResource() as! Resource<MovieListModel.Response>)
    }

    fileprivate func setupBindings(){
        
        reachability?.rx.isReachable
            .subscribe(onNext: { [weak self] isReachable in
                isReachable ? self?.fetchDataFromApi() :                 ToastView.shared.short(self?.view, txt_msg: "Please check your internet!")
            })
            .disposed(by: disposable)
        
        
        //        searchTextField
        //            .rx
        //            .text
        //            .orEmpty
        //            .bind(to: self.viewModel.searchText)
        //            .disposed(by: disposable)
        //
        //        searchTextField
        //            .rx
        //            .text
        //            .orEmpty
        //            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        //            .distinctUntilChanged()
        //            .bind(to: self.viewModel.searchText)
        //            .disposed(by: disposable)
        
        movieListVM
            .movieList
            .observeOn(MainScheduler.instance)
            .bind(to: movieListTableView.rx.items(cellIdentifier: MovieListCell.cellIdentifier, cellType: MovieListCell.self)) {  (row,vm,cell) in
                cell.eachCell = vm
            }
            .disposed(by: disposable)
        
        movieListVM
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                ToastView.shared.short(self?.view, txt_msg: "  \(error)  ")
            })
            .disposed(by: disposable)
        
    }
    
}
