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

    private func configureHeaderAndTableView() {
        let total = goals.count
        
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
            
            if addNewButton.isHidden {
                //show addButton
                addNewButton.isHidden = false
                addNewButton.alpha = 0
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.addNewButton.alpha = 1
                })
            }
            
            
            
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

        
        let results = stack.fetchGoal(type: .all, completed: .incomplete) as? [Goal]
        if results?.count != 0 {
            self.goals = results!
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
        self.navigationItem.title = "Home"
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
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-75)
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
    
    
    //MARK: TABLEVIEW DATASOURCE FUNCTIONS
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goals.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if duration is 0 we use ProjectCell
        if goals[indexPath.row].duration == 0 {
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
            cell.timedGoal = goals[indexPath.row]
            return cell
        }
        
    }
    
    
    //TABLEVIEW DELEGATE FUNCTIONS
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if goals[indexPath.row].duration > 0 && editingMode == false {
            let sessionVC = SessionViewController()
            let cell = tableView.cellForRow(at: indexPath)
            timedCellDelegate = cell as? UpVCToTimedProjectCellDelegate
            sessionVC.dismissedBlock = {
                self.timedCellDelegate.showBlackCheck()
                self.goals[indexPath.row].completionDate = Date()
                self.stack.saveTo(context: self.stack.viewContext)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: {
                    self.goals.remove(at: indexPath.row)
                    self.upTableView.deleteRows(at: [indexPath], with: .left)
                })
                
            }
            sessionVC.timedGoal = goals[indexPath.row]
            if goals[indexPath.row].completionDate == nil {
                self.present(sessionVC, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(index: indexPath)
        let edit = editAction(index: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    func deleteAction(index: IndexPath) -> UIContextualAction {
        let goal = goals[index.row]
        let action = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.stack.viewContext.delete(goal)
            self.stack.saveTo(context: self.stack.viewContext)
            self.goals.remove(at: index.row)
            self.upTableView.deleteRows(at: [index], with: .left)
            
            
            completion(true)
        }
        
        action.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        action.image = UIGraphicsImageRenderer(size: CGSize(width: 23, height: 23)).image { _ in
            #imageLiteral(resourceName: "deleteIcon").draw(in: CGRect(x: 0, y: 0, width: 22, height: 22))
        }
        return action
    }
    
    func editAction(index: IndexPath) -> UIContextualAction {
        let goal = goals[index.row]
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            let nextVC = NewProjectViewController()
            nextVC.selectedGoal = goal
            nextVC.selectedTime = Int(goal.duration)
            self.present(nextVC, animated: true, completion: nil)
            
            completion(true)
        }
        
        action.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        action.image = UIGraphicsImageRenderer(size: CGSize(width: 23, height: 23)).image { _ in
            #imageLiteral(resourceName: "editIcon").draw(in: CGRect(x: 0, y: 0, width: 23, height: 23))
        }
        return action
    }
    
    
    
    
    
    
}




extension UpViewController: TimedCellToUpVCDelegate, NonTimedCellToUpVCDelegate {
    
    
    func deleteTimedCell(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            stack.viewContext.delete(goals[index.row])
            stack.saveTo(context: stack.viewContext)
            goals.remove(at: index.row)
            upTableView.deleteRows(at: [index], with: .left)
            
        }
    }
    
    
    func completeNonTimedCell(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            goals[index.row].completionDate = Date()
            stack.saveTo(context: stack.viewContext)
            goals.remove(at: index.row)
            upTableView.deleteRows(at: [index], with: .left)
        }
    }
    
    func deleteNonTimedCell(cell: UITableViewCell) {
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


