//
//  SearchViewController.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

class SearchViewController: UIViewController {

    //MARK: variable
    var titles:[Title] = [Title]()
    let heightForRow: CGFloat = 150
    
    private let discoverTable:UITableView = {
       let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = AppConstants.placeholder
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        title = AppConstants.TopSearch
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    //MARK: searchData
    private func searchData(){
        APICaller.shared.getDiscoverMovies {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: -extension TableViewDelegate & DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let model = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: model.original_name ?? model.original_title ?? AppConstants.unknown, posterURL: model.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  heightForRow
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultController = searchController.searchResultsController as? SearchResultViewController else{
            print(AppConstants.errorOccured)
                  return
              }
        resultController.delegate = self
        APICaller.shared.search(with: query) {[weak self] result in
            switch result {
            case .success(let titles):
                resultController.titles = titles.filter { $0.poster_path != nil }
                DispatchQueue.main.async {
                    resultController.searchResultCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title,
              let overview = title.overview else {
            return
        }
        APICaller.shared.getMovie(with: titleName) {[weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview)
                    let vc = VideoPreviewViewController()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = VideoPreviewViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
