//
//  upViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import UIKit
import SnapKit



protocol UpVCToTimedProjectCellDelegate {
    func showBlackCheck()
}

protocol UpVCToUpVCHeaderDelegate {
    func alertHeaderView(total: Int)
}

class UpViewController: UIViewController {
    
    let stack = CoreDataStack.instance
    
    //MARK: OUTLETS
    var upTableView: UITableView!
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "lightBlueAdd"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    
    var tableHeaderView: HeaderView!
    
    
    //MARK: VARIABLES
    var headerDelegate: UpVCToUpVCHeaderDelegate!
    var goalCompletionDelegate: GoalCompletionDelegate!
    
    
    //PURPOSE: communication from this VC to timed Cell
    var timedCellDelegate: UpVCToTimedProjectCellDelegate!
    
    var goals: [Goal] = [] {
        didSet {
            configureHeaderAndTableView()
        }
    }

    private func configureHeaderAndTableView() {
        let total = goals.count
        
        if total != 0 {
    
            let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25)
            tableHeaderView.frame = tableHeaderFrame
            self.view.layoutIfNeeded()
        
        } else {
            
            let tableHeaderFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
            self.tableHeaderView.frame = tableHeaderFrame
            
            
        }
        
        headerDelegate.alertHeaderView(total: total)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks"
        setUp()
        fetchGoals() {
            self.upTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        upTableView.reloadData()
    }
    
    
}


extension UpViewController {
    //MARK: OBJ FUNCTIONS
    
    @objc func addButtonTapped() {
        let nextVC = NewProjectViewController()
        nextVC.goalDelegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    //MARK: PRIVATE FUNCTIONS
    
    private func fetchGoals(completion: @escaping () -> ()) {
        let results = stack.fetchGoal(type: .all, completed: .incomplete, sorting: .dateDescending) as? [Goal]
        if results?.count != 0 {
            self.goals = results!
        }
        completion()
    }
    
    private func addOutlets() {
        self.view.addSubview(addButton)
    }
    
    private func setConstraints() {
        addButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(10)
            make.height.width.equalTo(65)
        }
    }
    
    private func setUp() {
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        setUpTableView()
        addOutlets()
        setConstraints()
    }
    
    private func setUpTableView() {
        tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        self.upTableView = UITableView()
        self.upTableView.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.upTableView.separatorStyle = .none
        self.upTableView.delegate = self
        self.upTableView.dataSource = self
        self.upTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        self.upTableView.register(TimedProjectCell.self, forCellReuseIdentifier: "timedProjectCell")
        self.upTableView.tableHeaderView = tableHeaderView
        headerDelegate = tableHeaderView
        self.view.addSubview(upTableView)
        
        self.upTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }

    
}

extension UpViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: TABLEVIEW DATASOURCE FUNCTIONS
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        if goals[indexPath.row].duration > 0 {
            let cell = tableView.cellForRow(at: indexPath)
            let sessionVC = SessionViewController()
            timedCellDelegate = cell as? UpVCToTimedProjectCellDelegate
            sessionVC.dismissedBlock = {
                self.goals[indexPath.row].completionDate = Date()
                self.timedCellDelegate.showBlackCheck()
                self.goalCompletionDelegate.goalWasCompleted(goal: self.goals[indexPath.row])
                self.stack.saveTo(context: self.stack.viewContext)
            }
            
            sessionVC.timedGoal = goals[indexPath.row]
            DispatchQueue.main.async(execute: {
                self.present(sessionVC, animated: true, completion: nil)
            })
            
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! ProjectCell
            cell.complete()
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
            nextVC.selectedIndex = index.row
            nextVC.goalDelegate = self
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
    
    func completeTimedCell(cell: UITableViewCell) {
        if let index = upTableView.indexPath(for: cell) {
            goals.remove(at: index.row)
            upTableView.deleteRows(at: [index], with: .right)
        }
    }
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.goals[index.row].completionDate = Date()
                self.stack.saveTo(context: self.stack.viewContext)
                self.goalCompletionDelegate.goalWasCompleted(goal: self.goals[index.row])
                self.goals.remove(at: index.row)
                self.upTableView.deleteRows(at: [index], with: .right)
            }
            
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


extension UpViewController: newProjectVCToUpVCDelegate {
    
    func addGoalToUpVC(goal: Goal) {
        self.goals.insert(goal, at: 0)
        upTableView.reloadData()
    }
    
    func editGoalToUpVC(goal: Goal, index: Int) {
        self.goals[index] = goal
        upTableView.reloadData()
    }
    
    
}

