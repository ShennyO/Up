//
//  SessionViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/13/19.
//

import UIKit
import AudioToolbox

protocol SessionVCToTimeAnimationViewDelegate: class {
    
    func pauseAnimation()
    
    func resumeAnimation()
    
    func runAnimation(timeInSeconds: Int)
    
    func removeAnimations()
    
    func updateMinuteLabel(timeString: String)
    
}

class SessionViewController: UIViewController {

    //MARK: VARIABLES
    var timedGoal: Goal?
    var currentTime: TimeInterval!
    var endTime: TimeInterval!
    var sessionActive = false
    var timeInSeconds: Int = 0
    var addedTime: Int32 = 0
    var isSessionPaused = false
    
    weak var delegate: SessionVCToTimeAnimationViewDelegate!
    
    var pauseGesture: UITapGestureRecognizer?
    
    var dismissedBlock: (() -> ())?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: OUTLETS
    var blurEffectView: UIVisualEffectView!
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 30
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 30
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let congratsView = CongratulationsView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    let animationView = TimeAnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    let cancelView = CancelView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    
    //MARK: FUNCTIONS
    
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    //MARK: TIMER
    var timer: Timer!
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func runTimer() {
        timer = Timer()
        endTime = Date.timeIntervalSinceReferenceDate + Double(timeInSeconds)
        currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTimeDouble = endTime - currentTime
        let elapsedtimeInt = Int(elapsedTimeDouble)
        delegate.updateMinuteLabel(timeString: "\(timeString(time: elapsedtimeInt))")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTimeDouble = endTime - currentTime
        let elapsedtimeInt = Int(elapsedTimeDouble)
        self.timeInSeconds = elapsedtimeInt
        if elapsedtimeInt == 0 {
            showCongratsView()
        }
        delegate.updateMinuteLabel(timeString: "\(timeString(time: elapsedtimeInt))")
    }
    
    func timeString(time:Int) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours < 1 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        return String(format:"%2i:%02i:%02i", hours, minutes, seconds)
    }
    
    private func addOutlets() {
        [descriptionLabel, startButton, doneButton, cancelButton, animationView].forEach { (view) in
            self.view.addSubview(view)
        }
    }
    
    
    private func setCongratsCancelAndBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        blurEffectView.alpha = 0.7
        view.addSubview(blurEffectView)
        
        self.view.addSubview(congratsView)
        self.view.addSubview(cancelView)
        congratsView.delegate = self
        cancelView.delegate = self
        
        congratsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(325)
            make.centerY.equalToSuperview().offset(550)
        }
        
        cancelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
            make.height.equalTo(215)
            make.width.equalTo(300)
        }
        
    }
    
    
    private func setConstraints() {
    
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(125)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(80)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.height.width.equalTo(300)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
    }
    
    private func showCongratsView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate.removeAnimations()
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopTimer()
        blurEffectView.isHidden = false
        blurEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.blurEffectView.alpha = 0.7
        })
        
        congratsView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(325)
            make.centerY.equalToSuperview().offset(-25)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func doneButtonTapped() {
        showCongratsView()
    }
    
    @objc func startButtonTapped() {
        sessionActive = true
        runTimer()
        delegate.runAnimation(timeInSeconds: timeInSeconds)
        //hiding start button and showing done button
        doneButton.isHidden = false
        doneButton.alpha = 0
        doneButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.7, animations: {
            self.startButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.startButton.isHidden = true
        })
        
        UIView.animate(withDuration: 0.85, delay: 1.7, animations: {
            self.doneButton.alpha = 1
        }, completion: { (value: Bool) in
            self.doneButton.isUserInteractionEnabled = true
        })
        
    }
    
    @objc func cancelButtonTapped() {
        
        if sessionActive {
            
            stopTimer()
            delegate.pauseAnimation()
            
            blurEffectView.isHidden = false
            blurEffectView.alpha = 0
            cancelView.isHidden = false
            cancelView.alpha = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.blurEffectView.alpha = 0.7
                self.cancelView.alpha = 1.0
            })
            
            
        } else {
            
            self.dismiss(animated: true)
            
        }
    }
    
    
    @objc private func pauseGestureTapped() {
        
        if sessionActive == false {
            return
        }
        
        if isSessionPaused {
            isSessionPaused = false
            runTimer()
            delegate.resumeAnimation()
        } else {
            isSessionPaused = true
            stopTimer()
            delegate.pauseAnimation()
        }
        
    }
    
    private func setPauseGesture() {
        self.pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pauseGestureTapped))
        self.view.addGestureRecognizer(pauseGesture!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        addOutlets()
        setPauseGesture()
        setConstraints()
        setCongratsCancelAndBlur()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.delegate = self.animationView
        cancelView.isHidden = true
        
        if timedGoal != nil {
            timeInSeconds = Int(timedGoal!.duration) * 60
            descriptionLabel.text = timedGoal!.goalDescription
        }
        
        delegate.updateMinuteLabel(timeString: "\(timeString(time: timeInSeconds))")
        
    }
    
    deinit {
        print("Session VC Deinitialized!")
    }
    
}

extension SessionViewController: CongratsViewToSessionVCDelegate {
    
    func addButtonTapped(time: Int) {
        //only add the time, don't save the time here
        //only when the user has completed the task (when they press done) do we save the update
        self.addedTime += Int32(time)
        
        timeInSeconds += (time * 60)
        delegate.runAnimation(timeInSeconds: timeInSeconds)
        runTimer()
        
        congratsView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(325)
            make.centerY.equalToSuperview().offset(550)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.blurEffectView?.alpha = 0
            self.view.layoutIfNeeded()
        }, completion:  {
            (value: Bool) in
            self.blurEffectView?.isHidden = true
        })
        
    }
    
    func dismissTapped() {
        self.timedGoal?.duration += addedTime
        dismissedBlock!()
        self.dismiss(animated: true, completion: nil)
    }
}

extension SessionViewController: CancelViewToSessionVCDelegate {
    func yesTapped() {
        self.delegate.removeAnimations()
        stopTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelTapped() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView?.alpha = 0
            self.cancelView.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.blurEffectView?.isHidden = true
            self.cancelView.isHidden = true
        })
        
        delegate.resumeAnimation()
        runTimer()
        
    }
    
    
}
