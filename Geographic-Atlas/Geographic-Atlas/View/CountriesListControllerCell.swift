//
//  MainCollectionViewCell.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 13.05.2023.
//

import UIKit
import SnapKit


protocol CellButtonDelegate: AnyObject {
    func didPressButton(in cell: CountriesListControllerCell)
    
}




class CountriesListControllerCell: UICollectionViewCell {
 
    weak var delegate: CellButtonDelegate?
    
    override var isSelected: Bool {
          didSet {
              updateAppearance()
          }
      }
    private var expandedConstraint: Constraint!
      
      // MARK: Констрейнт для сжатого состояния
      private var collapsedConstraint: Constraint!
    
    lazy private var mainContainer = UIView()
    lazy private var topContainer = UIView()
    lazy private var bottomContainer = UIView()
    
    //MARK: TopContainer Elements
    lazy private var arrowImageView: UIImageView = {
          let imageView = UIImageView(image: UIImage(systemName:"chevron.down")!.withRenderingMode(.alwaysTemplate))
          imageView.tintColor = .black
          imageView.contentMode = .scaleAspectFit
          return imageView
      }()
    
    lazy private var flagImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.image = UIImage(named: "testing")
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        return imgView
    }()
    lazy private var countryName: UILabel = {
        let label = UILabel()
        label.text = "Japan"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    lazy private var capitalCity: UILabel = {
        let label = UILabel()
        label.text = "Tokyo"
        label.textColor = UIColor(named: "secondTextColor")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    //MARK: Bottom Container Elements

    lazy private var populationLabel: UILabel = {
        let label = UILabel()
        label.text = "Population:"
        label.textColor = UIColor(named: "secondTextColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private var areaLabel: UILabel = {
        let label = UILabel()
        label.text = "Area:"
        label.textColor = UIColor(named: "secondTextColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private var currenciesLabel: UILabel = {
        let label = UILabel()
        label.text = "Currencies:"
        label.textColor = UIColor(named: "secondTextColor")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private var populationAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "19 mln"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private  var areaAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "2.725 mln km²"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private var currenciesAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Tenge (₸) (KZT)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy private  var moreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Learn more", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.setTitleColor(.systemBlue, for: .normal)
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "background")
        contentView.layer.cornerRadius = 12
        moreButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        configureView()
    }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        
    }
    func configure(with country: CountryAPI) {
        countryName.text = country.name.common
        capitalCity.text = country.capital?.joined(separator: ", ") ?? ""
        populationAnswerLabel.text = "\(country.population ?? 0) mln"
        if currenciesName(of: country).isEmpty && currenciesSymbol(of: country).isEmpty {
            currenciesAnswerLabel.text = ""
        } else {
            currenciesAnswerLabel.text = "\(currenciesName(of: country))" + "(" + "\(currenciesSymbol(of: country))" + ")"
        }
        areaAnswerLabel.text = "\(country.area ?? 0) mln km²"
        let imageUrl = URL(string: country.flags.png)
        DispatchQueue.global().async {
                    if let url = imageUrl, let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.flagImageView.image = image
                            }
                        }
                    }
                }
        
       
    }
    func currenciesName(of country: CountryAPI) ->[String] {
        let names = country.currencies?.compactMap{$0.value.name}
        return names ?? []
        
    }
    func currenciesSymbol(of country: CountryAPI) ->[String] {
        let symbols = country.currencies?.compactMap{$0.value.symbol}
        return symbols ?? []
        
    }
  
    
    
    
    @objc private func buttonPressed() {
           delegate?.didPressButton(in: self)
       }
    
    private func updateAppearance() {
          collapsedConstraint.isActive = !isSelected
          expandedConstraint.isActive = isSelected

          UIView.animate(withDuration: 0.3) {
              let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999 )
              self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
          }
      }
}








extension CountriesListControllerCell {
        func configureView() {
            mainContainer.clipsToBounds = true
            topContainer.backgroundColor = UIColor(named: "background")
            bottomContainer.backgroundColor = UIColor(named: "background")
            
            let tapGesture = UITapGestureRecognizer()
            bottomContainer.addGestureRecognizer(tapGesture)
            contentView.layer.cornerRadius = 12
            contentView.clipsToBounds = true
            
            setUpViews()
            setUpConstraints()
                    
            
        }
        func setUpViews() {
            contentView.addSubview(mainContainer)

            
        }
        func setUpConstraints() {
            
            mainContainer.snp.makeConstraints{ make in
                make.edges.equalToSuperview()
            }
            mainContainer.addSubview(topContainer)
            mainContainer.addSubview(bottomContainer)
            
            topContainer.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(80)
                    }
                    
                
                    topContainer.snp.prepareConstraints { make in
                        collapsedConstraint = make.bottom.equalToSuperview().constraint
                        collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
                    }
            [arrowImageView,flagImageView,countryName,capitalCity].forEach {topContainer.addSubview($0)}
          
            
            flagImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(12)
                make.height.equalTo(50)
                make.width.equalTo(80)
            }
            countryName.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.leading.equalTo(flagImageView.snp.trailing).offset(12)
                make.width.equalTo(200)

            }
            capitalCity.snp.makeConstraints { make in
                make.top.equalTo(countryName.snp.bottom).offset(4)
                make.leading.equalTo(flagImageView.snp.trailing).offset(12)
            }
            [populationLabel,areaLabel,currenciesLabel,populationAnswerLabel,areaAnswerLabel,currenciesAnswerLabel,moreButton].forEach{bottomContainer.addSubview($0)}
            
            populationLabel.snp.makeConstraints {make in
                make.leading.equalToSuperview().inset(12)
                
            }
            populationAnswerLabel.snp.makeConstraints { make in
                make.leading.equalTo(populationLabel.snp.trailing).offset(4)
                
            }
            areaLabel.snp.makeConstraints {make in
                make.top.equalTo(populationLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview().inset(12)
            }
            areaAnswerLabel.snp.makeConstraints { make in
                make.top.equalTo(populationLabel.snp.bottom).offset(8)
                make.leading.equalTo(areaLabel.snp.trailing).offset(4)
            }
            currenciesLabel.snp.makeConstraints {make in
                make.top.equalTo(areaLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview().inset(12)
            }
            currenciesAnswerLabel.snp.makeConstraints { make in
                make.top.equalTo(areaLabel.snp.bottom).offset(8)
                make.leading.equalTo(currenciesLabel.snp.trailing).offset(4)

            }
            
            
            moreButton.snp.makeConstraints { make in
                make.top.equalTo(currenciesLabel.snp.bottom).offset(16)
                make.leading.equalToSuperview().inset(126)
            
            }
            
            
            arrowImageView.snp.makeConstraints { make in
                       make.height.equalTo(16)
                       make.width.equalTo(24)
                       make.centerY.equalToSuperview()
                       make.right.equalToSuperview().offset(-5)
                   }
                   
                   bottomContainer.snp.makeConstraints { make in
                       make.top.equalTo(topContainer.snp.bottom)
                       make.left.right.equalToSuperview()
                       make.height.equalTo(144)
                   }
                   
                   // MARK: Констрейнт для расширенного состояния (низ ячейки совпадает с низом нижнего контейнера)
                   bottomContainer.snp.prepareConstraints { make in
                       expandedConstraint = make.bottom.equalToSuperview().constraint
                       expandedConstraint.layoutConstraints.first?.priority = .defaultLow
                   }
               }
               

        }
    
