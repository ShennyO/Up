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
    
    func hideMinuteLabel()
    
    func showMinuteLabel()
    
}

class SessionViewController: UIViewController {

    
    //MARK: VARIABLES
    var timedGoal: Goal?
    var currentTime: TimeInterval!
    var endTime: TimeInterval!
    var originalTimeInSeconds = 0
    var timeInSeconds: Int = 0
    var addedTime: Int32 = 0
    var isSessionPaused = false
    var sessionActive = false
    var cancelViewShowing = false
    var congratsViewShowing = false
    
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
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 22))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = widthScaleFactor(distance: 30)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 22))
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = widthScaleFactor(distance: 30)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 22))
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 20))
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let pauseIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pauseIcon"))
        imageView.isHidden = true
        return imageView
    }()
    
    let congratsView = CongratulationsView(frame: CGRect(x: 0, y: 0, width: widthScaleFactor(distance: 300), height: widthScaleFactor(distance: 300)))
    
    let animationView = TimeAnimationView(frame: CGRect(x: 0, y: 0, width: widthScaleFactor(distance: 300), height: widthScaleFactor(distance: 300)))
    
    let cancelView = CancelView(frame: CGRect(x: 0, y: 0, width: widthScaleFactor(distance: 300), height: widthScaleFactor(distance: 200)))
    
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
    
    
    private func setViewsOverBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        blurEffectView.alpha = 0.7
        self.view.addSubview(blurEffectView)
    
        self.view.addSubview(congratsView)
        self.view.addSubview(cancelView)
        self.view.addSubview(pauseIcon)
        
        congratsView.delegate = self
        cancelView.delegate = self
        
        congratsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(widthScaleFactor(distance: 30))
            make.right.equalToSuperview().offset(widthScaleFactor(distance: -30))
            make.height.equalTo(widthScaleFactor(distance: 300))
            make.centerY.equalToSuperview().offset(heightScaleFactor(distance: 600))
        }
        
        cancelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(animationView.snp.centerY)
            make.height.equalTo(widthScaleFactor(distance: 216))
            make.width.equalTo(widthScaleFactor(distance: 300))
        }
        
        pauseIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(animationView.snp.centerY)
            make.height.width.equalTo(widthScaleFactor(distance: 40))
        }
        
    }
    
    
    private func setConstraints() {
        
        descriptionLabel.snp.makeConstraints { (make) in
            if UIScreen.main.bounds.height > 736 {
                make.top.equalToSuperview().offset(heightScaleFactor(distance: 140))
            } else {
                make.top.equalToSuperview().offset(heightScaleFactor(distance: 125))
            }
            
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 30))
            make.height.equalTo(widthScaleFactor(distance: 80))
        }
        
        animationView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.height.width.equalTo(widthScaleFactor(distance: 300))
        }
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(heightScaleFactor(distance: 32))
            make.centerX.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 60))
            make.width.equalTo(widthScaleFactor(distance: 150))
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(heightScaleFactor(distance: 32))
            make.centerX.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 60))
            make.width.equalTo(widthScaleFactor(distance: 150))
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 50))
            make.left.equalToSuperview().inset(widthScaleFactor(distance: 20))
            make.height.equalTo(widthScaleFactor(distance: 20))
        }
        
    }
    
    private func showCongratsView() {
        
        congratsViewShowing = true
        
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
            make.centerY.equalToSuperview().offset(heightScaleFactor(distance: -25))
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
        if sessionActive == false {
            self.dismiss(animated: true)
        } else {
            
            isSessionPaused = true
            cancelViewShowing = true
            
            stopTimer()
            delegate.pauseAnimation()
            
            blurEffectView.isHidden = false
            blurEffectView.alpha = 0
            cancelView.isHidden = false
            cancelView.alpha = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.blurEffectView.alpha = 0.4
                self.cancelView.alpha = 1.0
            })
        }
    }
    
    @objc private func pauseGestureTapped(gesture: UITapGestureRecognizer) {
        if sessionActive == false || cancelViewShowing == true || congratsViewShowing == true {
            return
        }
        
        var point = gesture.location(in: view)
        point = self.animationView.convert(point, from: self.view)
        
        if !self.animationView.bounds.contains(point) {
            return
        }
        
        if isSessionPaused {
            
            isSessionPaused = false
            pauseIcon.alpha = 1
            
            UIView.animate(withDuration: 0.4, animations: {
                self.pauseIcon.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.pauseIcon.isHidden = true
            })
            
            
            UIView.animate(withDuration: 0.2, animations: {
                self.blurEffectView?.alpha = 0
                self.view.layoutIfNeeded()
            }, completion:  {
                (value: Bool) in
                self.blurEffectView?.isHidden = true
            })
            
            runTimer()
            delegate.resumeAnimation()
            delegate.showMinuteLabel()
            
        } else {
            
            pauseIcon.isHidden = false
            pauseIcon.alpha = 0
            
            UIView.animate(withDuration: 0.1, animations: {
                self.pauseIcon.alpha = 1
            })
            
            isSessionPaused = true
            
            blurEffectView.isHidden = false
            blurEffectView.alpha = 0.2
            
            stopTimer()
            delegate.pauseAnimation()
            delegate.hideMinuteLabel()
        }
    }
    
    @objc private func appMovedToBackground() {
        if sessionActive && !cancelViewShowing && !congratsViewShowing{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.pauseIcon.isHidden = false
                self.pauseIcon.alpha = 0
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.pauseIcon.alpha = 1
                })
                
                self.isSessionPaused = true
                
                self.blurEffectView.isHidden = false
                self.blurEffectView.alpha = 0.2
                
                self.stopTimer()
                self.delegate.pauseAnimation()
                self.delegate.hideMinuteLabel()
            }
        }
    }
    
    private func setPauseGesture() {
        self.pauseGesture = UITapGestureRecognizer(target: self, action: #selector(pauseGestureTapped(gesture:)))
        self.view.addGestureRecognizer(pauseGesture!)
    }
    
    private func hideBlur() {
        UIView.animate(withDuration: 0.4, animations: {
            self.blurEffectView?.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.blurEffectView?.isHidden = true
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        addOutlets()
        setPauseGesture()
        setConstraints()
        setViewsOverBlur()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.delegate = self.animationView
        cancelView.isHidden = true
        
        if timedGoal != nil {
            timeInSeconds = Int(timedGoal!.duration) * 60
            originalTimeInSeconds = timeInSeconds
            descriptionLabel.text = timedGoal!.goalDescription
        }
        
        delegate.updateMinuteLabel(timeString: "\(timeString(time: timeInSeconds))")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    
}

extension SessionViewController: CongratsViewToSessionVCDelegate {
    
    
    func addButtonTapped(time: Int) {
        //only add the time, don't save the time here
        //only when the user has completed the task (when they press done) do we save the update
        
        congratsViewShowing = false
        
        self.addedTime += Int32(time)
        
        timeInSeconds += (time * 60)
        delegate.runAnimation(timeInSeconds: timeInSeconds)
        runTimer()
        
        congratsView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(325)
            make.centerY.equalToSuperview().offset(heightScaleFactor(distance: 600))
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
        cancelViewShowing = false
        isSessionPaused = false
        delegate.resumeAnimation()
        runTimer()
    }
    
    
}
