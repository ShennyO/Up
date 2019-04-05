//
//  upViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import UIKit
import SnapKit

class upViewController: UIViewController {
    
    
    //MARK: OUTLETS
    var upTableView = UITableView()
    
    //MARK: VARIABLES
    var projects: [Project] = [Project(title: "Wake up 6 A.M", description: "wake up don't waste time"), Project(title: "Example Title", description: "")]
    var timedProjects: [timedProject] = [timedProject(title: "Call with Yelp", description: "accept offer", time: "30"), timedProject(title: "work on Up", description: "spend 2-3 hrs on Up", time: "60")]
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
}

extension upViewController {
    //MARK: PRIVATE FUNCTIONS
    
    private func setUp() {
        configNavBar()
        self.title = "Up"
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        setUpTableView()
    }
    
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpTableView() {
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.view.addSubview(upTableView)
        
        self.upTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension upViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return projects.count
        } else {
            return timedProjects.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
            cell.selectionStyle = .none
            cell.project = projects[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timedProjectCell") as! TimedProjectCell
            cell.selectionStyle = .none
            cell.timedProject = timedProjects[indexPath.row]
            return cell
        }
        
       
        
    }
    
    
}
