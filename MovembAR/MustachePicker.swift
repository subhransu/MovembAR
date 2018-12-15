//
//  MustachePicker.swift
//  MovembAR
//
//  Created by nitin muthyala on 15/12/18.
//  Copyright © 2018 Subhransu Behera. All rights reserved.
//

import UIKit

class MustachePicker: UIView {
    
    // Elements
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self.frame , collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // Constants
    let cellId = "cellId"
    let cellHt: CGFloat = 80
    weak var delegate: PickerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func setupView() {
        self.addSubview(collectionView)
        
        // Constraints
        let pickerHt = frame.height - 32
        collectionView.heightAnchor.constraint(equalToConstant: pickerHt).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor,constant:16).isActive = true
        
        // Add delegates
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(MustacheCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MustachePicker : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MustacheCell
        let mousName = "moustache_\(indexPath.row + 1)"
        cell.configure(withImage: mousName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
        delegate?.didPickMustache(pos: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: cellHt)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

protocol PickerDelegate: NSObjectProtocol {
    func didPickMustache(pos: Int)
}

