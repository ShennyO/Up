//
//  SessionViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/13/19.
//

import UIKit

class SessionViewController: UIViewController {

    //MARK: VARIABLES
    var timedProject: TimedProject?
    var currentTime: TimeInterval!
    var endTime: TimeInterval!
    
    
    var timeInSeconds: Int = 0
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: OUTLETS
    
    let circleLayer = CAShapeLayer()
    let pulsatingLayer = CAShapeLayer()
    
    
    var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "Goal:"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6745760441, green: 0.6705681682, blue: 0.6776582003, alpha: 1)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    
    var minutesLabel: UILabel = {
        let label = UILabel()
        label.text = "30:00"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 45)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 5
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
    
    
    
    
    
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
   
    
    private func addLayer() {

        let point = CGPoint(x: view.center.x, y: view.center.y + 15)
        let circularPath = UIBezierPath(arcCenter: point, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        backgroundLayer.lineWidth = 12
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        self.view.layer.addSublayer(backgroundLayer)
        
        
        let pulsatingPath = UIBezierPath(arcCenter: point, radius: 112, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = pulsatingPath.cgPath
        pulsatingLayer.strokeColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        pulsatingLayer.lineWidth = 0
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        pulsatingLayer.opacity = 0
        self.view.layer.addSublayer(pulsatingLayer)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circleLayer.lineWidth = 12
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.strokeEnd = 0.8
        self.view.layer.addSublayer(circleLayer)
    }
    
    private func runAnimation() {
        //MARK: STROKE ANIMATION
        let circleBorderAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleBorderAnimation.toValue = 0
        circleBorderAnimation.duration = Double(timeInSeconds)
        circleLayer.add(circleBorderAnimation, forKey: "borderAnimation")
        
        //MARK: PULSATING ANIMATION
        let pulsatingAnimation = CABasicAnimation(keyPath: "lineWidth")
        pulsatingAnimation.toValue = 12
        pulsatingAnimation.duration = 1.5
        pulsatingAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulsatingAnimation.autoreverses = true
        pulsatingAnimation.repeatCount = .greatestFiniteMagnitude
        pulsatingLayer.add(pulsatingAnimation, forKey: "pulsingAnimation")
        
        //MARK: OPACITY ANIMATION
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 0.6
        opacityAnimation.duration = 1.5
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulsatingLayer.add(opacityAnimation, forKey: "opacityAnimation")

    }
    
    //MARK: TIMER
    var timer = Timer()
    
    
    func runTimer() {
        endTime = Date.timeIntervalSinceReferenceDate + Double(timeInSeconds)
        currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTimeDouble = endTime - currentTime
        let elapsedtimeInt = Int(elapsedTimeDouble)
        minutesLabel.text = "\(timeString(time: elapsedtimeInt))" //This will update the label.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTimeDouble = endTime - currentTime
        let elapsedtimeInt = Int(elapsedTimeDouble)
        minutesLabel.text = "\(timeString(time: elapsedtimeInt))" //This will update the label.
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
        [goalLabel, descriptionLabel, minutesLabel, startButton, doneButton, cancelButton].forEach { (view) in
            self.view.addSubview(view)
        }
        
    }
    
    private func setConstraints() {
        
        goalLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goalLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        minutesLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(minutesLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(125)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(minutesLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(125)
        }
        
        
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
    }
    
    @objc func doneButtonTapped() {
        print("ok")
    }
    
    @objc func startButtonTapped() {
        runAnimation()
        runTimer()
        //hiding start button and showing done button
        doneButton.isHidden = false
        doneButton.alpha = 0
        UIView.animate(withDuration: 0.7, animations: {
            self.startButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.startButton.isHidden = true
            
        })
        
        UIView.animate(withDuration: 0.85, delay: 1.7, animations: {
            self.doneButton.alpha = 1
        })
        
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timedProject != nil {
            timeInSeconds = timedProject!.time * 60
            descriptionLabel.text = timedProject!.description
        }
        minutesLabel.text = "\(timeString(time: timeInSeconds))"
        configNavBar()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        addOutlets()
        addLayer()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
}
