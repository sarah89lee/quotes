//
//  ProfileQuotesTableViewCell.swift
//  Quotes
//
//  Created by Sarah Lee on 4/12/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

enum ProfileQuotesTableViewCellType: Int {
    case SaidBy
    case HeardBy
}

class ProfileQuotesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    fileprivate let collectionFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: - UIView Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(collectionView)
        
        collectionView.pinToAllSidesOfParent()
        
        collectionView.register(
            UINib(nibName: "ProfileFeedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ProfileFeedCollectionViewCell"
        )
    }
    
    // MARK: - Public Methods
    
    func selectCollectionViewIndex(index: Int) {
        let indexPath: IndexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: UICollectionViewScrollPosition.left
        )
    }
}

// MARK: -

extension ProfileQuotesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
}

// MARK: -

extension ProfileQuotesTableViewCell: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedCollectionViewCell", for: indexPath) as! ProfileFeedCollectionViewCell
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let generateUsersAndQuotesController = appDelegate.generateUsersAndQuotesController else {
            return cell
        }
        
        if indexPath.row == ProfileQuotesTableViewCellType.SaidBy.rawValue {
            cell.quotesDatasource = generateUsersAndQuotesController.getLoggedInUserSaidByQuotes()
        } else {
            cell.quotesDatasource = generateUsersAndQuotesController.getLoggedInUserHeardByQuotes()
        }
        
        cell.tableView.reloadData()
        
        return cell
    }
    
}
