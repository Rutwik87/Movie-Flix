//
//  HomeViewModel.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 12/03/22.
//

import Foundation
import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
}


class HomeViewModel: NSObject {
    
    var filteredData: [Movie] = []
    
    var data: [Movie] = [] {
        didSet{
            delegate?.updateUI()
        }
    }
    
    var isSearching = false
    
    weak var delegate: HomeViewModelDelegate?
    
    var numberOfItems: Int {
        return isSearching ? filteredData.count : data.count
    }
        
    override init() {
        super.init()
        loadMoviesData()
    }
    
    // API Call
    func loadMoviesData() {
        NetworkManager.shared.fetchMovies {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.data = response.results
                }
            case .failure(_):
                self.loadMoviesData()
            }
        }
    }
    
    func loadBackdropImage(index: Int, completion: @escaping (_ img: UIImage?)->Void) {
        
        let data = isSearching ? filteredData[index] : data[index]
        NetworkManager.shared.backdropImage(movie: data) { (result) in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func loadPosterImg(index: Int, completion: @escaping (_ img: UIImage?)->Void) {
        
        let data = isSearching ? filteredData[index] : data[index]
        NetworkManager.shared.posterImage(movie: data) { (result) in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func isPopularMovie(index: Int) -> Bool {
        let votes = isSearching ? filteredData[index].voteAverage : data[index].voteAverage
        return votes > 7.0
    }
    
    func changeFilteredData(searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { movie -> Bool in
            return movie.title.lowercased().contains(searchText)
        }
    }
    
    func deleteRow(index: Int) {
        let _ = isSearching ? filteredData.remove(at: index) : data.remove(at: index)
    }
    
    func getTitle(index: Int) -> String {
        let movie = isSearching ? filteredData[index] : data[index]
        return movie.title
    }
    
    func getOverview(index: Int) -> String {
        let movie = isSearching ? filteredData[index] : data[index]
        return movie.overview
    }
    
    func isDataEmpty() -> Bool {
        return isSearching ? filteredData.isEmpty : data.isEmpty
    }
}
