//
//  MovieListModel.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation

enum MovieListModel{
    
    struct Response : Codable {
        let page : Int?
        let results : [Results]?
        let total_pages : Int?
        let total_results : Int?
    }
    
    struct Results : Codable {
        let adult : Bool?
        let backdrop_path : String?
        let genre_ids : [Int]?
        let id : Int?
        let original_language : String?
        let original_title : String?
        let overview : String?
        let popularity : Double?
        let poster_path : String?
        let release_date : String?
        let title : String?
        let video : Bool?
        let vote_average : Double?
        let vote_count : Int?
    }
    
    struct Request: Decodable {
        
    }

}

