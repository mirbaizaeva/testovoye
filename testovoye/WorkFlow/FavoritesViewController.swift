//
//  FavoritesViewController.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import UIKit

class FavoritesViewController: UIViewController {

    private lazy var tableView: UITableView = {
            let view = UITableView()
            view.dataSource = self
            view.delegate = self
            view.backgroundColor = Constants.Color.baseColor
            view.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        var charactersViewController: ViewController?
        
        var likedCharsFromUD: [Result] {
            get {
                let data = UserdefaultStorage.shared.getDataWithKey(forKey: .favoritesArray)
                let results = try? JSONDecoder().decode([Result].self, from: data)
                return results ?? []
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setup()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tableView.reloadData()
        }

        func setup() {
            view.backgroundColor = Constants.Color.baseColor
            setupLayouts()
        }

        func setupLayouts() {
            view.addSubviews(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            likedCharsFromUD.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else {return UITableViewCell()}
            let model = likedCharsFromUD[indexPath.row]
            cell.config(character: model)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            120
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let delegateViewController = charactersViewController else {return}
            let detailsViewController = DetailsViewController()
            
            detailsViewController.delegate = delegateViewController
            detailsViewController.config(character: likedCharsFromUD[indexPath.row])
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
}
