//
//  CryptoListController.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import UIKit
import Combine

class CryptoListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let viewModel = CryptoViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupDetails()
        self.bindViewModel()
        viewModel.fetchCryptoListWIthCombine()
    }
    
    private func setupDetails() {
        
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(marketLabel)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            marketLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            marketLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: marketLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
    }
    
    private func bindViewModel(){
        
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: CryptoCoinCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 40/255, green: 38/255, blue: 42/255, alpha: 1)
        //UIColor(white: 0.2, alpha: 1.0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    private var marketLabel: UILabel = {
        
        let marketLbl = UILabel()
        marketLbl.text = "Market"
        marketLbl.textColor = .white
        marketLbl.font = .systemFont(ofSize: 30, weight: .bold)
        marketLbl.translatesAutoresizingMaskIntoConstraints = false
        return marketLbl
    }()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let coinCell = self.tableView.dequeueReusableCell(withIdentifier: CryptoCoinCell.identifier, for: indexPath) as? CryptoCoinCell
        coinCell?.configureCell(with: indexPath.row, itemList: viewModel.items)
        return coinCell!
    }

}
