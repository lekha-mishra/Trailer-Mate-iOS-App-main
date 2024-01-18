//
//  HeroHeaderUIView.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import UIKit

//MARK: -protocol
protocol HeroHeaderViewDelegate: NSObject{
    func playButtonTappedDelegate()
    func downloadButtonTappedDelegate()
}

class HeroHeaderUIView: UIView {
    
    //MARK: - Outlets
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let downlaodButton:UIButton = {
        let button = UIButton()
        button.setTitle(AppConstants.download, for: .normal)
        button.layer.borderWidth = AppConstants.borderWidth
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = true
        button.layer.cornerRadius = AppConstants.cornerRadius
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let playButton:UIButton = {
        let button = UIButton()
        button.setTitle(AppConstants.play, for: .normal)
        button.layer.borderWidth = AppConstants.borderWidth
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = true
        button.layer.cornerRadius = AppConstants.cornerRadius
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Delegate
    var delegate:HeroHeaderViewDelegate?
    
    //MARK: - function
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downlaodButton)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.label.cgColor
        ]
        gradient.frame  = bounds
        layer.addSublayer(gradient)
    }
    
    @objc func playButtonTapped(){
        print(AppConstants.playButtonTappped)
        delegate?.playButtonTappedDelegate()
    }
    @objc func downloadButtonTapped(){
        print(AppConstants.downloadButtonTappped)
        delegate?.downloadButtonTappedDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError(AppConstants.fetalError)
    }
    
    //MARK: - applyConstraintsApply
    func applyConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:80)
        let bottomConstraint = playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        let widthConstraint = playButton.widthAnchor.constraint(equalToConstant: 100)
        NSLayoutConstraint.activate([leadingConstraint, bottomConstraint, widthConstraint])
        
        downlaodButton.translatesAutoresizingMaskIntoConstraints = false
        let downloadButtonConstraints = [
            downlaodButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            downlaodButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downlaodButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
}
