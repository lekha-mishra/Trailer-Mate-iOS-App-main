//
//  CollectionViewTableViewCell.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

//MARK: -Protocol
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    //MARK: variable
    static let identifier = AppConstants.collectionViewCellIdentifier
    var titles: [Title] = [Title]()
    
    //MARK: Delegate
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let colllection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colllection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return colllection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.fetalError)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles:[Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: -downloadTitle
    private func downloadTitleAt(indexPath:IndexPath) {
        print("downloading movie: \(titles[indexPath.row].original_title)")
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print(AppConstants.movieDownloaded)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.dowloaded) , object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: -Extenstion
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let posterPath = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: posterPath)
        return cell
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
                strongSelf.delegate?.collectionViewTableViewCellDidTap(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: AppConstants.download, subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
               
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
