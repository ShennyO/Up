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
    let infoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "AddButton Copy"), for: .normal)
//        button.addTarget(self, action:#selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: VARIABLES
    var projects: [Project] = [Project(title: "Finish Up", description: "")]
    var timedProjects: [timedProject] = [timedProject(title: "Call with Yelp", description: "accept offer", time: "30"), timedProject(title: "work on Up", description: "spend 2-3 hrs on Up", time: "60"), timedProject(title: "Call with Yelp", description: "accept offer", time: "30"), timedProject(title: "Test3", description: "", time: "30")]
    
    
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
        self.view.addSubview(infoButton)
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
        self.upTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.upTableView.register(instructionCell.self, forCellReuseIdentifier: "instructionCell")
        self.view.addSubview(upTableView)
        
        self.upTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func setConstraints() {
        infoButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(65)
        }
    }
    
}

extension upViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: TABLEVIEW FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return HeaderViewHelper.createTasksTitleHeaderView(title: "Tasks", fontSize: 25, frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150), color: #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1))
        } else {
            return HeaderViewHelper.createTasksTitleHeaderView(title: "Sessions", fontSize: 25, frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150), color: #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1))
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if projects.count == 0 {
                return 50
            }
        } else {
            if timedProjects.count == 0 {
                return 50
            }
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if projects.count == 0 {
                return 1
            }
            return projects.count
        } else {
            if timedProjects.count == 0 {
                return 1
            }
            return timedProjects.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if projects.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell") as! instructionCell
                cell.setUpCell(type: .untimed)
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
            cell.selectionStyle = .none
            cell.project = projects[indexPath.row]
            return cell
        } else {
            if timedProjects.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell") as! instructionCell
                cell.setUpCell(type: .timed)
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "timedProjectCell") as! TimedProjectCell
            cell.selectionStyle = .none
            cell.timedProject = timedProjects[indexPath.row]
            return cell
        }
        
       
        
    }
    
    
}
