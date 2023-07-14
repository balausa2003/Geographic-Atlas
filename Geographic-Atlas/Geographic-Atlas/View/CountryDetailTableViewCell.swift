//
//  CountryDetailTableViewCell.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 16.05.2023.
//

import UIKit

class CountryDetailTableViewCell: UITableViewCell {
    
   lazy private var dotLabel: UILabel = {
        let label = UILabel()
        label.text = "•"
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    
    }()
    lazy private var infoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "secondTextColor")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
        
    }()
     lazy private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "hello"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setText(text: String) {
        infoLabel.text = text
    }
    func setResult(country: String) {
        resultLabel.text = country
    }
    
}
extension CountryDetailTableViewCell {
    func setUpViews() {
        
        [dotLabel,infoLabel,resultLabel].forEach{ contentView.addSubview($0)}
        
    }
    func setUpConstraints() {
        dotLabel.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(16)
            
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.leading.equalTo(dotLabel.snp.trailing).offset(8)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(5)
            make.leading.equalTo(dotLabel.snp.trailing).offset(8)
            make.width.equalTo(200)
          
            
        }
    }
}
