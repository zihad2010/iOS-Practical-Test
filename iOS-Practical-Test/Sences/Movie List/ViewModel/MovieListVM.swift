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
    public let info: PublishSubject<Int> = PublishSubject()
    public let movieList : PublishSubject<[String]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<String> = PublishSubject()
    private let movieInfo = BehaviorRelay<String>(value: "")
    
}

