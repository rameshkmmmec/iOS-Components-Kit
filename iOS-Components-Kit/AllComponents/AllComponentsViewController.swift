//
//  AllComponentsViewController.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit

class AllComponentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let components = ComponentItem.allItems
    
    private let tableView: UITableView = {
        let tableVw = UITableView(frame: .zero, style: .insetGrouped)
        tableVw.separatorStyle = .none
        tableVw.register(ComponentCell.self, forCellReuseIdentifier: ComponentCell.identifier)
        tableVw.translatesAutoresizingMaskIntoConstraints = false
        return tableVw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    func setupLayout(){
        
        self.title = "All components"
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ComponentCell.identifier,
            for: indexPath
        ) as? ComponentCell else {
            return UITableViewCell()
        }
        cell.configure(with: components[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = components[indexPath.row]
        let vc = ComponentRouter.destination(for: selected.routeKey)
        navigationController?.pushViewController(vc, animated: true)
    }
}
