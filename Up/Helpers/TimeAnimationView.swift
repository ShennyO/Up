//
//  TimeAnimationView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/5/19.
//

import UIKit

class TimeAnimationView: UIView {
    
    //MARK:LAYERS
    let circleLayer = CAShapeLayer()
    let pulsatingLayer = CAShapeLayer()
    
    //MARK: OUTLETS
    var minutesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 45)
        label.text = "30:00"
        label.textColor = UIColor.white
        return label
    }()
    
    
    private func addOutlets() {
        self.addSubview(minutesLabel)
    }
    
    private func setConstraints() {
        minutesLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(2)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func addAnimationLayers() {
        
        let point = CGPoint(x: self.center.x, y: self.center.y)
        let circularPath = UIBezierPath(arcCenter: point, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        backgroundLayer.lineWidth = 12
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        self.layer.addSublayer(backgroundLayer)
        
        
        let pulsatingPath = UIBezierPath(arcCenter: point, radius: 112, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer.path = pulsatingPath.cgPath
        pulsatingLayer.strokeColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        pulsatingLayer.lineWidth = 0
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        pulsatingLayer.opacity = 0
        self.layer.addSublayer(pulsatingLayer)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        circleLayer.lineWidth = 12
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.strokeEnd = 0.8
        self.layer.addSublayer(circleLayer)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOutlets()
        addAnimationLayers()
        setConstraints()
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("timeAnimationView deinitialized")
    }
    

}

extension TimeAnimationView: SessionVCToTimeAnimationViewDelegate {
    
    func resumeAnimation() {
        let pausedCircleTime: CFTimeInterval = circleLayer.timeOffset
        circleLayer.speed = 1.0
        circleLayer.timeOffset = 0.0
        circleLayer.beginTime = 0.0
        let timeSincePauseForCircle: CFTimeInterval = circleLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedCircleTime
        circleLayer.beginTime = timeSincePauseForCircle
        
        let pausedPulsatingTime: CFTimeInterval = pulsatingLayer.timeOffset
        pulsatingLayer.speed = 1.0
        pulsatingLayer.timeOffset = 0.0
        pulsatingLayer.beginTime = 0.0
        let timeSincePauseForPulsate: CFTimeInterval = pulsatingLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedPulsatingTime
        pulsatingLayer.beginTime = timeSincePauseForPulsate
        
    }
    
    func pauseAnimation() {
        
        //CircleLayer
        let pausedCircleTime: CFTimeInterval = circleLayer.convertTime(CACurrentMediaTime(), from: nil)
        circleLayer.speed = 0.0
        circleLayer.timeOffset = pausedCircleTime
        
        //PulsatingLayer
        let pausedPulsatingTime: CFTimeInterval = pulsatingLayer.convertTime(CACurrentMediaTime(), from: nil)
        pulsatingLayer.speed = 0.0
        pulsatingLayer.timeOffset = pausedPulsatingTime
        
    }
    
    func updateMinuteLabel(timeString: String) {
        self.minutesLabel.text = timeString
    }
    
    func runAnimation(timeInSeconds: Int) {
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
    
    func removeAnimations() {
        [self.circleLayer, self.pulsatingLayer].forEach { (layer) in
            layer.removeAllAnimations()
        }
    }
    
    
}
