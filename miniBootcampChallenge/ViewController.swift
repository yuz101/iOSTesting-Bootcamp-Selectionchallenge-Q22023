//
//  ViewController.swift
//  miniBootcampChallenge
//

import UIKit

class ViewController: UICollectionViewController {
    
    private struct Constants {
        static let title = "Mini Bootcamp Challenge"
        static let cellID = "imageCell"
        static let cellSpacing: CGFloat = 1
        static let columns: CGFloat = 3
        static var cellSize: CGFloat?
    }
    
    private var loadingIndicator: UIActivityIndicatorView!
    private lazy var urls: [URL] = URLProvider.urls
    private var imageList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        setupLoadingIndicator()
        getAllImages()
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func getAllImages() {
        DispatchQueue.global(qos: .userInitiated).async {
            ImageAPI.getAllImage(withURLs: self.urls) { result in
                switch result {
                case .success(let images):
                    self.imageList.append(contentsOf: images)
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


// TODO: 1.- Implement a function that allows the app downloading the images without freezing the UI or causing it to work unexpected way

// TODO: 2.- Implement a function that allows to fill the collection view only when all photos have been downloaded, adding an animation for waiting the completion of the task.


// MARK: - UICollectionView DataSource, Delegate
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.display(self.imageList[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionView FlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.cellSize == nil {
          let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (Constants.columns * Constants.cellSpacing - 1)
            Constants.cellSize = (view.frame.size.width - emptySpace) / Constants.columns
        }
        return CGSize(width: Constants.cellSize!, height: Constants.cellSize!)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.cellSpacing
    }
}
