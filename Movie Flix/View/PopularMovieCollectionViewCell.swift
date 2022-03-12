//
//  PopularMovieCollectionViewCell.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 10/03/22.
//

import UIKit

class PopularMovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "PopularMovieCollectionViewCell"
    
    var index: Int?
    weak var delegate: MovieCellDelegate?
    
    
    var backdropImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        imgView.image = UIImage(named: "placeholder-img")
        return imgView
    }()
    
    var deleteButton: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "trash")
        img.tintColor = .red
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        return img
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImgView.image = UIImage(named: "placeholder-img")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backdropImgView)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            backdropImgView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backdropImgView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backdropImgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDeleteBtn(_:)))
        deleteButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapDeleteBtn(_ sender: UITapGestureRecognizer) {
        delegate?.deleteTapped(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellWithImg(img: UIImage?, index: Int) {
        backdropImgView.image = img ?? UIImage(named: "placeholder-img")
        self.index = index
    }
}
