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
    
    let stack = CoreDataStack.instance
    
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
    //PURPOSE: to alert the HeaderView when to enable and disable the edit button
    var headerDelegate: UpVCToUpVCHeaderDelegate!
    
    //PURPOSE: communication from this VC to timed Cell
    var timedCellDelegate: UpVCToTimedProjectCellDelegate!
    var editingMode = false
    
    var goals: [Goal] = [] {
        didSet {
            configureHeaderAndTableView()
        }
    }
    var timedGoals: [Goal] = [] {
        didSet {
            
            configureHeaderAndTableView()
        }
    }
    
    private func configureHeaderAndTableView() {
        let total = goals.count + timedGoals.count
        
        if total != 0 {
            
            let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
            tableHeaderView.frame = tableHeaderFrame
            self.view.layoutIfNeeded()
            
            
            
        } else { //when Projects are at zero, edit button is automatically disabled, and add button is
            // automatically shown and enabled
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
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
    

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGoals() {
            self.upTableView.reloadData()
        }
        
    }
    
    private func fetchGoals(completion: @escaping () -> ()) {
        let results = fetchGoalFromCoreData(entityName: "Goal", type: .untimed) as? [Goal]
        if results?.count != 0 {
            self.goals = results!
        }
        let timedResults = fetchGoalFromCoreData(entityName: "Goal", type: .timed) as? [Goal]
        if timedResults?.count != 0 {
            self.timedGoals = timedResults!
        }
        
        
        completion()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchGoals() {
            
            self.upTableView.reloadData()
        }
       
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
//        let results = fetchGoalFromCoreData(entityName: "Goal", type: .all)
//        if results?.count == 0 {
//            tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "Today")
//        } else {
//            tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100), title: "Today")
//        }
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
            return goals.count
        } else {
            return timedGoals.count
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.index = indexPath
            cell.goal = goals[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timedProjectCell") as! TimedProjectCell
            cell.selectionStyle = .none
            cell.index = indexPath
            cell.delegate = self
            cell.timedGoal = timedGoals[indexPath.row]
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
                self.timedGoals[indexPath.row].completion = true
                self.stack.saveTo(context: self.stack.viewContext)
            }
            sessionVC.timedGoal = timedGoals[indexPath.row]
            if timedGoals[indexPath.row].completion == false {
                self.present(sessionVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
}

extension UpViewController {
    
}

extension UpViewController: TimedCellToUpVCDelegate, NonTimedCellToUpVCDelegate {

    //Extension here is for the tableviewcell button to communicate with VC
    //VC handles which cell and project to delete

    func passTimedCellIndex(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            stack.viewContext.delete(timedGoals[index.row])
            stack.saveTo(context: stack.viewContext)
//            fetchGoals()
            timedGoals.remove(at: index.row)

            upTableView.deleteRows(at: [index], with: .left)
            
        }
    }

    func passNonTimedCellIndex(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            stack.viewContext.delete(goals[index.row])
            stack.saveTo(context: stack.viewContext)
            goals.remove(at: index.row)
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


