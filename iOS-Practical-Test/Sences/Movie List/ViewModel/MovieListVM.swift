//
//  MovieListVM.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListVM {
    
    private let disposable = DisposeBag()
    public let movieList : PublishSubject<[MovieListCellVM]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<String> = PublishSubject()
    private let movieInfo = BehaviorRelay<String>(value: "")
    
}

extension MovieListVM {
    
    public func createResource() -> Any {
        
        guard var url = URL.moviePath else {
            fatalError("URl was incorrect")
        }
        url.appendQueryItem(name: APIKEY, value: KEY )
        url.appendQueryItem(name: QUERY, value: "marvel")

        var resource = Resource<MovieListModel.Response>(url: url)
        resource.httpMethod = .get
        
        return resource
    }
    
    func getDataWith<T>(resource: Resource<T>)  {
        
        self.loading.onNext(true)
        
        NetworkManager
            .shared
            .load(resource: resource)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] response in
                self?.loading.onNext(false)
                switch response{
                case .success(let data):
                    self?.convertWith(data as! MovieListModel.Response)
                case .failure(let failure):
                    switch failure {
                    case .authorizationError(_):
                        break
                    default:
                        self?.error.onNext("Something went wrong!")
                    }
                }
            }, onError: {[weak self] (error) in
                self?.loading.onNext(false)
            })
            .disposed(by: disposable)
    }
    
    fileprivate func convertWith(_ vm:MovieListModel.Response) {
        
        guard let vm = vm.results?.map({MovieListCellVM($0)}) else { return }
        self.movieList.onNext(vm)
    }
}

