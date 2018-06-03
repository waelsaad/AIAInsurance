//
//  ImgurViewController.swift
//  AIAInsurance
//
//  Created by Wael Saad on 03/6/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//
import UIKit

enum SegueIdentifier: String {
    case reuseIdentifier = "ImgurCollectionImageCell"
}

class ImgurViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, NetworkResponse {
    
    var viewModel : ImgurViewModel!
    
    // Saves the Size of cell in a cache so that can be used to relayout cell
    private var cellSizeCache = NSCache<NSIndexPath, NSValue>()
    
    @IBOutlet var filterSwitch: UISwitch!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Default image used to get dimensions of cell before downloading anything
    let initialImage: UIImage = UIImage(named: APPIMAGES.NoImage)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images"
        viewModel = ImgurViewModel.init(delegate: self)
        showActivityIndicator()
        searchBar.text = "Jesus"
        refreshData(searchText: searchBar.text!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refreshData(searchText: searchBar.text!)
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        
        viewModel.isFiltered = filterSwitch.isOn
        refreshData(searchText: searchBar.text!)
        refreshUI()
    }
    
    func refreshData (searchText: String) -> Void {
        viewModel.refreshData(searchText: searchText)
    }
    
    // Add a refresh activity indicator on the navigation bar
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    // Hide the refresh activity indicator once loaded all the images
    func hideActivityIndicator() {
        navigationItem.rightBarButtonItem = nil
    }
    
    // Refresh the UI and remove the refresh control
    func refreshUI() {
        self.cellSizeCache.removeAllObjects()
        self.collectionView?.reloadData()
        hideActivityIndicator()
        if viewModel.imageList.count > 0 {
            self.collectionView?.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top)
        } else {
            //self.displayAlert("AIAInsurance", message: "No records found", okBlock: nil)
        }
    }
    
    func defaultSizeForImageView() -> CGSize {
        return initialImage.size
    }
    
    func stateChanged(success: Bool, error: String) {
        if !success {
            self.displayAlert("Error", message: error, okBlock: nil)
        }
        refreshUI()
    }
    
    // Handle the layout on device rotation and based on dimentions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension ImgurViewController {
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegueIdentifier.reuseIdentifier.rawValue, for: indexPath) as! ImgurCollectionViewCell
        cell.loadData(viewModel: viewModel.viewModelForCell(at: indexPath.row), delegate: self)
        return cell
    }
}

extension ImgurViewController: ImageDownloaded {
    // Gets the size of cell and cache it.
    func resizeCell(at index: Int, size: CGSize) {
        let indexPath = NSIndexPath.init(item: index, section: 0)
        cellSizeCache.setObject(NSValue(cgSize: size), forKey: indexPath)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewFlowLayout Delegate

extension ImgurViewController: UICollectionViewDelegateFlowLayout {
    
    // Get the size of cell and calculate the height based on the collection view constraint

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize  {
        var insets: CGFloat = 0.0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            insets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        }
        let elementsCount = CGFloat(2)
        let size = UIScreen.main.bounds.width / elementsCount - insets
        return CGSize(width: size, height: size)
    }
}


