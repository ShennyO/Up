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

protocol UpVCToTimedProjectCellDelegate {
    func showBlackCheck()
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
    //this is to alert the HeaderView when to enable and disable the edit button
    var headerDelegate: UpVCToUpVCHeaderDelegate!
    var timedCellDelegate: UpVCToTimedProjectCellDelegate!
    var editingMode = false
    
    var projects: [Project] = [] {
        didSet {
            let total = projects.count + timedProjects.count
            
            if total != 0 {
                
                let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
                tableHeaderView.frame = tableHeaderFrame
                
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                
                
            } else { //when Projects are at zero, edit button is automatically disabled, and add button is
                     // automatically shown and enabled
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                    // Code you want to be delayed
                    let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                    self.tableHeaderView.frame = tableHeaderFrame
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
                
                
                
                //show addButton
                addNewButton.isHidden = false
                addNewButton.alpha = 0
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.addNewButton.alpha = 1
                })
                
            }
            headerDelegate.alertHeaderView(total: total)
            
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
                
            } else { //if total is 0, editing mode is automatically changed back to false
                editingMode = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { 
                    // Code you want to be delayed
                    let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
                    self.tableHeaderView.frame = tableHeaderFrame
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
                //show addButton
                addNewButton.isHidden = false
                addNewButton.alpha = 0
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.addNewButton.alpha = 1
                })
                
            }
            headerDelegate.alertHeaderView(total: total)
            
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
        tableHeaderView.delegate = self
        headerDelegate = tableHeaderView
        self.upTableView = UITableView()
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.upTableView.tableHeaderView = tableHeaderView
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
            make.width.height.equalTo(60)
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
        if indexPath.section == 1 && editingMode == false {
            let sessionVC = SessionViewController()
            let cell = tableView.cellForRow(at: indexPath)
            timedCellDelegate = cell as? UpVCToTimedProjectCellDelegate
            sessionVC.dismissedBlock = {
                self.timedCellDelegate.showBlackCheck()
                self.timedProjects[indexPath.row].completion = true
                

            }
            sessionVC.timedProject = timedProjects[indexPath.row]
            if timedProjects[indexPath.row].completion == false {
                self.present(sessionVC, animated: true, completion: nil)
            }
        }
    }
    
}

extension UpViewController: TimedCellDelegate, NonTimedCellDelegate {
    
    //Extension here is for the tableviewcell button to communicate with VC
    //VC handles which cell and project to delete
    
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

extension UpViewController: HeaderViewToUpVCDelegate {
    func alertUpVCOfEditMode(mode: Bool) {
        //if editMode is on
        editingMode = mode
        if mode == true {
            //hide addButton
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewButton.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.addNewButton.isHidden = true
                
            })
            
        } else { //if editMode is off
            
            //show addButton
            addNewButton.isHidden = false
            addNewButton.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
                self.addNewButton.alpha = 1
            })
            
        }
        
    }
    
    
}


