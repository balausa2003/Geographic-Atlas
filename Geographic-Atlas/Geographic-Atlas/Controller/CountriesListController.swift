//
//  ViewController.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 13.05.2023.
//

import UIKit
import SnapKit

class CountriesListController: UIViewController {
    var countryData: [CountryAPI] = []
    private let sizingCell = CountriesListControllerCell()
    
    private lazy var collectionView: UICollectionView = {
        let layout = JumpAvoidingFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = true
        view.alwaysBounceVertical = true
        return view
    }()

    override func viewDidLoad() {
        self.title = "World Countries"
        view.backgroundColor = .white
        collectionView.register(CountriesListControllerCell.self, forCellWithReuseIdentifier: Constants.Identifiers.CountriesListControllerCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        APICaller.shared.handleRequest { [weak self] result in
            switch result {
            case .success(let countryData):
                self?.countryData = countryData
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
        
        setUpViews()
        setUpConstraints()
        super.viewDidLoad()
    }
    
   
    
}
extension CountriesListController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.CountriesListControllerCell, for: indexPath) as! CountriesListControllerCell
        cell.delegate = self
        let country = countryData[indexPath.item]
        cell.configure(with: country)
        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
            let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            
            sizingCell.frame = CGRect(
                origin: .zero,
                size: CGSize(width: collectionView.bounds.width - 40, height: 20)
            )
            
            sizingCell.isSelected = isSelected
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()

            let size = sizingCell.systemLayoutSizeFitting(
                CGSize(width: collectionView.bounds.width - 40, height: .greatestFiniteMagnitude),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )

            return size
        }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            12
        }
   
    
    
    
    
}
extension CountriesListController: UICollectionViewDelegate, CellButtonDelegate {
    func didPressButton(in cell: CountriesListControllerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
                   return
               }
       let selectedCountry = countryData[indexPath.row]
       
               let vc = CountryDetailsViewController()
               vc.configureWithData(with: selectedCountry)
               navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.performBatchUpdates(nil)
            return true
        }
        
        // MARK: Переопределяем метод для анимированного разворачивания ячейки
        func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            collectionView.performBatchUpdates(nil)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            // MARK: И скроллим так, чтобы при разворачивании ячейки ее было полностью видно
            DispatchQueue.main.async {
                guard collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) != nil else {
                    return
                }
                
            }
            
            return true
        }
  
    
    
}

extension CountriesListController {
    func setUpViews() {
        view.addSubview(collectionView)
    }
    func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

