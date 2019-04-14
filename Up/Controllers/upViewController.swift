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
    var upTableView: UITableView!
    let addNewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "AddButton Copy"), for: .normal)
        button.addTarget(self, action:#selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: VARIABLES
    var projects: [Project] = [Project(description: "Go out to eat with Fam"), Project(description: "Hang out with Victor")]
    var timedProjects: [timedProject] = [timedProject(description: "accept offer", time: "30"), timedProject(description: "spend 2-3 hrs on Up", time: "60"), timedProject(description: "accept offer", time: "30")]
//    var projects: [Project] = []
//    var timedProjects: [timedProject] = []
    
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
        self.view.addSubview(addNewButton)
        setConstraints()
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
        self.upTableView = UITableView()
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.upTableView.register(instructionCell.self, forCellReuseIdentifier: "instructionCell")
        self.upTableView.tableHeaderView = HeaderViewHelper.createTasksTitleHeaderView(title: "Today", fontSize: 30, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 75), color: #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1))
        self.view.addSubview(upTableView)
        
        self.upTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func setConstraints() {
        addNewButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(50)
        }
    }
    
    @objc private func addButtonTapped() {
        let nextVC = NewProjectViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
    
}

extension upViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: TABLEVIEW FUNCTIONS
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if projects.count == 0 && timedProjects.count == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if projects.count == 0 {
                return 50
            }
        } else if indexPath.section == 1 {
            if timedProjects.count == 0 {
                return 50
            }
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projects.count == 0 && timedProjects.count == 0 {
            return 1
        }
        if section == 0 {
            return projects.count
        } else {
            return timedProjects.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if projects.count == 0 && timedProjects.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell") as! instructionCell
            cell.setUpCell()
            return cell
        }
        
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
