//
//  CardViewController.swift
//  K-lab-project
//
//  Created by 정소은 on 11/21/23.
//


import UIKit

class CardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cards: [(question: String, answer: String?)] = [
        ("What's your favorite color?", nil),
        // Add more questions and answers as needed
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
    }
    
    // ... (이전 코드와 동일)
}
