//
//  HomeViewController.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 10/03/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK:- Properties
    private var homeViewModel: HomeViewModel!
    
    // MARK:- IBOutlets
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        callToViewModelForUIUpdate()
    }
}

// MARK:- Helper Functions
extension HomeViewController {

    func callToViewModelForUIUpdate() {
        homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
    }
    
    fileprivate func initialSetup() {
        moviesCollectionView.register(PopularMovieCollectionViewCell.self, forCellWithReuseIdentifier: PopularMovieCollectionViewCell.identifier)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        searchBar.delegate = self
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if homeViewModel.isPopularMovie(index: indexPath.item) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCollectionViewCell.identifier, for: indexPath) as! PopularMovieCollectionViewCell
            homeViewModel.loadBackdropImage(index: indexPath.item) { img in
                cell.configureCellWithImg(img: img,index: indexPath.item)
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            cell.titleLabel.text = homeViewModel.getTitle(index: indexPath.item)
            cell.overviewLabel.text = homeViewModel.getOverview(index: indexPath.item)
            homeViewModel.loadPosterImg(index: indexPath.item) { img in
                cell.configureCellWithImg(img: img, index: indexPath.item)
            }
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.loadPosterImg(index: indexPath.item) { img in
            self.navigateToDetailsVC(img: img)
        }
    }
    
    func navigateToDetailsVC(img: UIImage?) {
        let detailsVC = DetailsViewController()
        detailsVC.imgView.image = img
        detailsVC.modalPresentationStyle = .fullScreen
        present(detailsVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if homeViewModel.isPopularMovie(index: indexPath.item) {
            return CGSize(width: view.frame.size.width - 40, height: 200)
        } else {
            return CGSize(width: view.frame.size.width - 40, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        homeViewModel.isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        homeViewModel.isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviesCollectionView.performBatchUpdates({
            homeViewModel.changeFilteredData(searchText: searchText.lowercased())
        }, completion: { _ in
            if !self.homeViewModel.isDataEmpty() {
                self.moviesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: MovieCellDelegate {
    func deleteTapped(index: Int?) {
        guard let index = index else { return }
        moviesCollectionView.performBatchUpdates({
            homeViewModel.deleteRow(index: index)
        }, completion: nil)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func updateUI() {
        moviesCollectionView.reloadData()
    }
}

