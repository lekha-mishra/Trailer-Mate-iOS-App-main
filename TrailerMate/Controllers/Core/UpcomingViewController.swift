//
//  UpcomingViewController.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

class UpcomingViewController: UIViewController {

    //MARK: variable
    var titles:[Title] = [Title]()
    let heightForRow: CGFloat = 150
    
    private let upcomingTable:UITableView = {
       let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        title = AppConstants.upComing
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: -Extension TableViewDelegate
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
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
        return heightForRow
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
