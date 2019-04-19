//
//  upViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import UIKit
import SnapKit


protocol UpVCToUpVCHeaderDelegate {
    func alertHeaderView(total: Int)
}

class UpViewController: UIViewController {
    
    
    //MARK: OUTLETS
    var upTableView: UITableView!
    let addNewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "AddButton Copy"), for: .normal)
        button.addTarget(self, action:#selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var tableHeaderView: HeaderView!
    
    
    //MARK: VARIABLES
    
    var delegate: UpVCToUpVCHeaderDelegate!
    
    var projects: [Project] = [] {
        didSet {
            let total = projects.count + timedProjects.count
            if total != 0 {
                
                let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
                tableHeaderView.frame = tableHeaderFrame
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                
                
            } else {
                let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                tableHeaderView.frame = tableHeaderFrame
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            delegate.alertHeaderView(total: total)
            
        }
    }
    var timedProjects: [TimedProject] = [] {
        didSet {
            let total = projects.count + timedProjects.count
            if total != 0 {
                
                
                let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
                tableHeaderView.frame = tableHeaderFrame
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                
            } else {
                let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                tableHeaderView.frame = tableHeaderFrame
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
            delegate.alertHeaderView(total: total)
            
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    
}


extension UpViewController {
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
        tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "Today")
        
        delegate = tableHeaderView
        self.upTableView = UITableView()
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.upTableView.tableHeaderView = tableHeaderView
//        self.upTableView.backgroundView = upTableViewBackgroundView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
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
    
    
    //MARK: OBJC FUNCTIONS
    
    @objc private func addButtonTapped() {
        let nextVC = NewProjectViewController()
        nextVC.sendSelectedProject = { (result) in
            self.projects.append(result)
            self.upTableView.reloadData()
        }
        
        nextVC.sendSelectedTimedProject = { result in
            self.timedProjects.append(result)
            self.upTableView.reloadData()
        }
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
}

extension UpViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: TABLEVIEW FUNCTIONS
    
    
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
            cell.delegate = self
            cell.index = indexPath
            cell.project = projects[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timedProjectCell") as! TimedProjectCell
            cell.selectionStyle = .none
            cell.index = indexPath
            cell.delegate = self
            cell.timedProject = timedProjects[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let sessionVC = SessionViewController()
            sessionVC.timedProject = timedProjects[indexPath.row]
            self.present(sessionVC, animated: true, completion: nil)
        }
    }
    
}

extension UpViewController: TimedCellDelegate, NonTimedCellDelegate {
    func passTimedCellIndex(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            timedProjects.remove(at: index.row)
            upTableView.deleteRows(at: [index], with: .left)
        }
    }
    
    func passNonTimedCellIndex(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            projects.remove(at: index.row)
            upTableView.deleteRows(at: [index], with: .left)
        }
    }
    
    
    
}


