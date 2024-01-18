//
//  SearchResultViewController.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

//MARK: -Protocol
protocol SearchResultViewControllerDelegate:AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    //MARK: variable
    public var titles: [Title] = [Title]()
    
    //MARK: Delegate
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 6, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

//MARK: -extension CollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        let posterPath = titles[indexPath.row].poster_path
        cell!.configure(with: posterPath ?? "")
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let titleName = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name else {
            return
        }
        APICaller.shared.getMovie(with: titleName + AppConstants.trailer) {[weak self] result in
            switch result{
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let overview = title?.overview else { return }
                guard let strongSelf = self else { return }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview)
                strongSelf.delegate?.searchResultViewControllerDidTapItem(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


