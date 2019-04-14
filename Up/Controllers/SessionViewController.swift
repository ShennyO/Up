//
//  SessionViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/13/19.
//

import UIKit

class SessionViewController: UIViewController {

    //MARK: VARIABLES
    var project: Project?
    var timedProject: timedProject?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: OUTLETS
    
    let circleLayer = CAShapeLayer()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Study the JTAppleCalendar and customize it"
        label.textColor = UIColor.white
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
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        backgroundLayer.lineWidth = 10
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        self.view.layer.addSublayer(backgroundLayer)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        self.view.layer.addSublayer(circleLayer)
    }
    
    private func runAnimation() {
        let circleBorderAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleBorderAnimation.toValue = 0
        circleBorderAnimation.duration = 3
        circleLayer.add(circleBorderAnimation, forKey: "borderAnimation")
    }
    
    private func addOutlets() {
        [descriptionLabel, minutesLabel, startButton].forEach { (view) in
            self.view.addSubview(view)
        }
        
    }
    
    private func setConstraints() {
        
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(125)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        minutesLabel.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        
        
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(minutesLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(125)
        }
        
    }
    
    @objc func startButtonTapped() {
        runAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        addOutlets()
        addLayer()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
}
