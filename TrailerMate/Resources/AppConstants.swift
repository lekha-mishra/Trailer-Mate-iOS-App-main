//
//  AppConstants.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import Foundation

struct AppConstants {
    static let borderWidth = 1.0
    static let cornerRadius = 8.0    
    static let movieDownloaded = "movie downloaded"
    static let dowloaded = "downloaded"
    static let download = "Download"
    static let trailer = " trailer"
    static let playButtonTappped = "play button tapped"
    static let downloadButtonTappped = "download button tapped"
    static let playCircle = "play.circle"
    static let HarryPorter = "Harry Porter"
    static let bestMovie = "This is the best movie to watch."
    static let house = "house"
    static let home = "home"
    static let ComingSoon = "Coming Soon"
    static let TopSearch = "Top Search"
    static let magnifyingglass = "magnifyingglass"
    static let arrowDowntoLine = "arrow.down.to.line"
    static let upComing = "Upcoming"
    static let unknown = "Unknown"
    static let placeholder = "Search for a Movie or Tv show."
    static let downloadingMovie = "downloading movie:"
    static let topSearch = "Top Search"
    static let defaults = "default"
    static let endRouting = "end routing"
    static let presentRouting = "present routing"
    static let netflix = "netflix"
    static let person = "person"
    static let unknownName = "Unknown Name"
    static let DeleteFromDatabase = "Deleted fromt the database"
    static let unknownTitleName = "Unknown title name"
    static let errorOccured = "error occured"
    static let fetalError = "init(coder:) has not been implemented"
    static let collectionViewCellIdentifier = "CollectionViewTableViewCell"
    static let play = "Play"
    static let titleColectionViewCellIdentifier = "TitleColectionViewCell"
    static let upcomingTableViewCellIdentifier = "UpcomingTableViewCell"
    static let titleTableViewCellIdentifier = "TitleTableViewCell"
}

struct MoviesCategory {
    
    let title: String
    
    
    static func defaultMoviesList() -> [MoviesCategory] {
        
        var CategoryList = [MoviesCategory]()
        CategoryList.append(MoviesCategory(title: "Trending Movies"))
        CategoryList.append(MoviesCategory(title: "trending Tv"))
        CategoryList.append(MoviesCategory(title: "Popular"))
        CategoryList.append(MoviesCategory(title: "Upcoming Movies"))
        CategoryList.append(MoviesCategory(title: "Top Rated"))
        return CategoryList
    }
}

