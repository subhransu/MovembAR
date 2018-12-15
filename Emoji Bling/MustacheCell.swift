//
//  MustacheCell.swift
//  MovembAR
//
//  Created by nitin muthyala on 15/12/18.
//  Copyright © 2018 Subhransu Behera. All rights reserved.
//

import UIKit

class MustacheCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let lbl = UIImageView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupImage()
        configure()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func setupImage() {
        self.addSubview(image)
        image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        image.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
    func configure() {
        image.image = #imageLiteral(resourceName: "moustache_0")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
