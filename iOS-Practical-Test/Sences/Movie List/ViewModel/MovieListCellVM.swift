//
//  MovieListCellVM.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation

struct MovieListCellVM {
    let title: String?
    let description: String?
    let coverUrl: URL?
    
    init(_ vm: MovieListModel.Results){
        self.title = vm.title
        self.description = vm.overview
        self.coverUrl = .posterPath(vm.poster_path ?? "")
    }
}
