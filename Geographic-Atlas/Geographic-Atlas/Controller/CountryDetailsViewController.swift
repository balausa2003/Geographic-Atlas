//
//  DetailViewController.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 16.05.2023.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    var country: CountryAPI?
    
    private lazy var flagImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "testing")
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        return imgView

    }()
    
    lazy private var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(CountryDetailTableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.CountryDetailTableViewCell)
       tableView.allowsSelection = false
       tableView.showsVerticalScrollIndicator = false
       tableView.separatorStyle = .none
       tableView.backgroundColor = .clear

        return tableView
    }()


    override func viewDidLoad() {
        view.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        setUpViews()
        setUpConstraints()
        
        super.viewDidLoad()
       

      
    }
    func configureWithData(with data: CountryAPI) {
      
        country = data
        let imageURL = URL(string: country?.flags.png ?? "testing")
        DispatchQueue.global().async {
            if let url = imageURL , let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.flagImageView.image = image
                     
                    }
                }
            }
        }
    }
    


}

extension CountryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.CountryDetailTableViewCell, for: indexPath) as! CountryDetailTableViewCell
  
        
        
        switch indexPath.row {
        case 0:
            cell.setText(text: "Region:")
            cell.setResult(country: country?.region ?? "")
            
        case 1:
            cell.setText(text: "Capital:")
            cell.setResult(country: country?.name.common ?? "")
            
        case 2:
            cell.setText(text: "Capital coordinates:")
            cell.setResult(country: "["+"\(country?.capitalInfo?.latlng?[0] ?? 0)" + "," + "\(country?.capitalInfo?.latlng?[1] ?? 0)" + "]")
        case 3:
            cell.setText(text: "Population:")
            cell.setResult(country: "\(country?.population ?? 0)")
        case 4:
            cell.setText(text: "Area:")
            cell.setResult(country: "\(country?.area ?? 0)" )
        case 5:
            cell.setText(text: "Currency:")
        
            cell.setResult(country: "\(country?.currenciesName(of: country!)[0] ?? "")")
        default:
            cell.setText(text: "Timezones:")
            cell.setResult(country:"\(country?.timezones![0] ?? "")")
        }
        
        

            
            
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
  
    
}


extension CountryDetailsViewController {
    func setUpViews() {
        view.addSubview(flagImageView)
        view.addSubview(tableView)
        
    }
    func setUpConstraints() {
        flagImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(343)
            make.height.equalTo(193)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(flagImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
