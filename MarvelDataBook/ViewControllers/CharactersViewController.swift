//
//  CharactersViewController.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    @IBOutlet weak var characterCollectionView: UICollectionView!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var pullRefreshControl: UIRefreshControl!
    
    var offset = 0
    var marvelCharacters = [MarvelCharacter]()
    var isFavoriteScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPullToRefresh()
        setParameters()
        registerCollectionView()
        fetchMarvelCharacters()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > (marvelCharacters.count - 4) && (marvelCharacters.count > 6) && !isFavoriteScreen {
            offset += 20
            fetchMarvelCharacters()
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func setPullToRefresh() {
        pullRefreshControl = UIRefreshControl()
        self.characterCollectionView.alwaysBounceVertical = true
        self.pullRefreshControl.tintColor = .gray
        self.pullRefreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        self.characterCollectionView.refreshControl = pullRefreshControl
    }
    
    @objc func refreshCollectionView() {
        self.characterCollectionView!.refreshControl?.beginRefreshing()
        self.characterCollectionView.reloadData()
        stopRefreshing()
     }
    
    func stopRefreshing() {
        self.characterCollectionView!.refreshControl?.endRefreshing()
     }
    
    func setParameters() {
        let tabTitle = parent?.restorationIdentifier
        self.title = tabTitle
        isFavoriteScreen = tabTitle == "Favorites" ? true : false
    }
    
    func registerCollectionView() {
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
    }
    
    private func showEmptyView(errorType: ErrorType) {
        let rect = CGRect(x: 0, y: 0,
                          width: self.characterCollectionView.bounds.size.width,
                          height: self.characterCollectionView.bounds.size.height)
        let emptyViewLabel: UILabel = UILabel(frame: rect)
        emptyViewLabel.text = errorType == ErrorType.fetching
            ? "Ocorreu um erro com a recuperação dos dados."
            : "Ocorreu um erro com a serialização dos dados."
        emptyViewLabel.textAlignment = .center
        emptyViewLabel.textColor = UIColor.gray
        emptyViewLabel.sizeToFit()
        
        self.characterCollectionView.backgroundView = emptyViewLabel
    }
    
    func fetchMarvelCharacters(name: String? = nil) {
        DispatchQueue.main.async {
            self.startActivityIndicator()
        }
        
        if (!isFavoriteScreen) {
            MarvelDataBookService.fetchMarvelCharacters(offset, name: name) { result in
                switch result {
                case .success(let marvelCharacter):
                    self.marvelCharacters.append(contentsOf: marvelCharacter)
                    DispatchQueue.main.async {
                        self.characterCollectionView.reloadData()
                        self.stopActivityIndicator()
                    }
                case .failure(let error):
                    self.showEmptyView(errorType: error)
                    return
                }
            }
        } else {
            //FavoriteDataBookService.fetchMarvelCharacters() {
            DispatchQueue.main.async {
                self.characterCollectionView.reloadData()
                self.stopActivityIndicator()
            }
        }
    }
}

extension CharactersViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marvelCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCard", for: indexPath) as! CharacterViewCell
        let marvelCharacter = marvelCharacters[indexPath.row]
        cell.character = marvelCharacter
        return cell
    }
}
