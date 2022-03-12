//
//  MovieCollectionViewCell.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 10/03/22.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func deleteTapped(index: Int?)
}

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"
    
    var index: Int?
    weak var delegate: MovieCellDelegate?
    
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        return titleLabel
    }()
    
    var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var deleteButton: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: "trash")
        img.tintColor = .red
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        return img
    }()
    
    var posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.image = UIImage(named: "placeholder-img")
        return imgView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImgView.image = UIImage(named: "placeholder-img")
        titleLabel.text = nil
        overviewLabel.text = nil
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            posterImgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImgView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            posterImgView.widthAnchor.constraint(equalToConstant: 175)
        ])
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: posterImgView.rightAnchor,constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: deleteButton.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            overviewLabel.leftAnchor.constraint(equalTo: posterImgView.rightAnchor,constant: 10),
            overviewLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 5),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
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
        posterImgView.image = img ?? UIImage(named: "placeholder-img")
        self.index = index
    }
}
