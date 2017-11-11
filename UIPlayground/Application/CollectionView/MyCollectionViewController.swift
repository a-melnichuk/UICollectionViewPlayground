//
//  MyCollectionViewController.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log
class MyCollectionViewController: UIViewController, UICollectionViewDelegate, OneBigTwoSmallGridDelegate, BaseView {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MyCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyCollectionViewModel(self)
        
        let oneBigTwoSmallGridLayout = collectionView.collectionViewLayout as? OneBigTwoSmallGridLayout
        os_log("oneBigTwoSmallGridLayout is %@", oneBigTwoSmallGridLayout == nil ? "nil" : "not nil")
        oneBigTwoSmallGridLayout?.delegate = self
        
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewModel.list.bind(to: collectionView) { items, indexPath, collectionView in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MyCollectionViewCell",
                for: indexPath) as! MyCollectionViewCell
            cell.item = items[indexPath.row]
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: OneBigTwoSmallGridDelegate
    
    func getItemSpacing() -> CGFloat {
        return 16.0
    }
    
    func getBigItemSpan() -> CGFloat {
        return 0.66
    }
    
    func getItemTypes() -> [OneBigTwoSmallGridItemType] {
        // return [.big, .small, .small]
         return [.small, .small, .big]
    }
    
}
