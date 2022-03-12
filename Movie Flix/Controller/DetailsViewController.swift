//
//  DetailsViewController.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 12/03/22.
//

import UIKit

class DetailsViewController: UIViewController {

    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.image = UIImage(named: "placeholder-img")
        return imgView
    }()
    
    var closeBtn: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "xmark.circle")
        imgView.tintColor = .white
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imgView)
        view.addSubview(closeBtn)
        
        NSLayoutConstraint.activate([
            imgView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imgView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imgView.topAnchor.constraint(equalTo: view.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCloseBtn(sender:)))
        closeBtn.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapCloseBtn(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}
