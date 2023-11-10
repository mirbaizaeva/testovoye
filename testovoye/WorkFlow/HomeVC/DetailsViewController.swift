//
//  DetailsViewController.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import UIKit

class DetailsViewController: UIViewController {

    private lazy var productPicture: UIImageView = {
            let view = UIImageView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 160
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var productName: UILabel = {
            let view = UILabel()
            view.font = .systemFont(ofSize: 20, weight: .bold)
            view.numberOfLines = 1
            view.textAlignment = .center
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var productDescription: UILabel = {
            let view = UILabel()
            view.font = .systemFont(ofSize: 14, weight: .medium)
            view.numberOfLines = 1
            view.textColor = .systemYellow
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var episodesCount: UILabel = {
            let view = UILabel()
            view.font = .systemFont(ofSize: 18, weight: .bold)
            view.backgroundColor = Constants.Color.episodeColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var likeButton: UIButton = {
            let view = UIButton()
            view.setImage(UIImage(systemName: "heart"), for: .normal)
            view.tintColor = .red
            view.addTarget(self, action:#selector(likeCharacter), for: .touchUpInside)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private lazy var tableView: UITableView = {
            let view = UITableView()
            view.dataSource = self
            view.delegate = self
            view.register(CustomInfoCell.self, forCellReuseIdentifier: CustomInfoCell.id)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        var delegate: Delegate?
        var likedOne: Result?
        
        private let viewModel: DetailsViewModel
        var isLiked: Bool?
        
        var episodesURLs = [String]()
        var episodes = [Episodes]()
        var color: UIColor?
        
        init() {
            viewModel = DetailsViewModel()
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            viewModel = DetailsViewModel()
            super.init(coder: coder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            fetchEpisodes()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            guard let id = likedOne?.id else {return}
            isLiked = UserdefaultStorage.shared.get(forKey: "\(id)")
            
            likeButton.setImage(UIImage(
                systemName: isLiked ?? false ? "heart.fill" : "heart",
                withConfiguration: Constants.ImageSize.config), for: .normal)
        }
        
        func setColor(status: String) -> UIColor {
            if status == "Alive" {
                return UIColor.systemGreen
            } else if status == "Dead" {
                return UIColor.systemRed
            } else {
                return UIColor.systemBlue
            }
        }
        
        func config(character to: Result) {
            color = setColor(status: to.status.rawValue)
            
            cimbinedLabel(text1: to.name, text2: " ( \(to.status.rawValue) ) ", color: color!)
            productDescription.text = "( \(to.species.rawValue) - \(to.gender.rawValue) )"
            episodesCount.text = "  Episodes ( \(to.episode.count) )"
            
            DispatchQueue.global(qos: .userInitiated).async {
                guard let data = ImageDownloader(
                    urlString: to.image
                ).donwload()
                else {
                    return
                }
                DispatchQueue.main.async {
                    self.productPicture.image = UIImage(data: data)
                }
            }
            
            likedOne = to
            self.episodesURLs = to.episode
        }
        
        func cimbinedLabel(text1: String, text2: String, color: UIColor) {
            let color1 = UIColor.black
            let color2 = color
            
            let attributedText = NSMutableAttributedString()
            
            let attributes1: [NSAttributedString.Key: Any] = [.foregroundColor: color1,]
            let attributedText1 = NSAttributedString(string: text1, attributes: attributes1)
            attributedText.append(attributedText1)
            
            let attributes2: [NSAttributedString.Key: Any] = [.foregroundColor: color2,]
            let attributedText2 = NSAttributedString(string: text2, attributes: attributes2)
            attributedText.append(attributedText2)
            
            productName.attributedText = attributedText
        }
        
        func fetchEpisodes() {
            for i in 0...(episodesURLs.count - 1) {
                viewModel.fetchEpisodes(url: episodesURLs[i]) { ep in
                    self.episodes.append(ep)
                }
            }
            self.tableView.reloadData()
        }
        
        private func setupUI() {
            view.backgroundColor = .white
            productPicture.layer.borderWidth = 5
            productPicture.layer.borderColor = color!.cgColor
            setupLayouts()
        }
        private func setupLayouts() {
            view.addSubviews(productPicture, productName, likeButton, productDescription, episodesCount, tableView)
            
            NSLayoutConstraint.activate([
                productPicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                productPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                productPicture.heightAnchor.constraint(equalToConstant: 320),
                productPicture.widthAnchor.constraint(equalToConstant: 320),
                
                likeButton.bottomAnchor.constraint(equalTo: productPicture.bottomAnchor),
                likeButton.trailingAnchor.constraint(equalTo: productPicture.trailingAnchor),
                likeButton.heightAnchor.constraint(equalToConstant: 50),
                likeButton.widthAnchor.constraint(equalToConstant: 50),
                
                productName.topAnchor.constraint(equalTo: productPicture.bottomAnchor, constant: 20),
                productName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                productName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
                
                productDescription.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10),
                productDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                episodesCount.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 10),
                episodesCount.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                episodesCount.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                episodesCount.heightAnchor.constraint(equalToConstant: 40),
                
                tableView.topAnchor.constraint(equalTo: episodesCount.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        @objc func likeCharacter() {
            guard let id = likedOne?.id else {return}
            guard let isLiked = isLiked else {return}
            
            if !isLiked {
                delegate?.didReceive(id)
            } else {
                delegate?.remove(id)
            }
        
            likeButton.setImage(UIImage(
                systemName: viewModel.liked(String(id)),
                withConfiguration: Constants.ImageSize.config
            ), for: .normal)
        }
    }

    extension DetailsViewController: UITableViewDataSource , UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            episodes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomInfoCell.id, for: indexPath) as! CustomInfoCell
            cell.config(episode: episodes[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            60
        }
        
    }
