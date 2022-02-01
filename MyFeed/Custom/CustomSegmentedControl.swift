//
//  CustomSegmentedControl.swift
//  MyFeed
//
//  Created by Lakshmi K on 25/11/21.
//

import UIKit

class CustomSegmentedControl: UIView {

    
    private var buttonTitles : [String]!
    private var buttons : [UIButton] = []
    private var selectorView : UIView!
    private var barSlideView : UIView!
    public private(set) var selectedIndex : Int = 0

    
    var textColor : UIColor = UIColor(rgb: 0xA8A6B5)
    var selectedTextColor : UIColor = .white
    var selectedBGColor : UIColor = UIColor(rgb: 0x5C5E6C)
    weak var delegate : CustomSegmentedControlDelegate?
    
    
    private func updateView() {
        createButtons()
        configureSelectorView()
        configureStackView()
    }
    
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    private func configureSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttons.count)

        selectorView = UIView(frame: CGRect(x: 0, y: 10, width: selectorWidth - 5, height: frame.height - 20))
        selectorView.layer.cornerRadius = 17.5
        selectorView.layer.masksToBounds = true
        selectorView.backgroundColor = selectedBGColor
        
        addSubview(selectorView)
        
        
        barSlideView = UIView(frame: CGRect(x: selectorWidth * 2, y: 15, width: 2, height: frame.height - 30))
        barSlideView.layer.cornerRadius = 2
        barSlideView.layer.masksToBounds = true
        barSlideView.backgroundColor = textColor
        
        addSubview(barSlideView)
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
            
        }
        buttons[0].setTitleColor(selectedTextColor, for: .normal)
    }
    
    @objc func buttonAction(sender : UIButton) {
        for (buttonIndex , btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
           
            if btn == sender {
                barSlideView.alpha = 0

                let selectorWidth = frame.width / CGFloat(self.buttons.count)
                if buttonIndex == 0 {
                    UIView.animate(withDuration: 0.4) {
                        self.barSlideView.frame.origin.x = selectorWidth * 2
                        self.barSlideView.alpha = 1
                    }
                }
                else if buttonIndex == 2 {
                    UIView.animate(withDuration: 0.4) {
                        self.barSlideView.frame.origin.x = selectorWidth
                        self.barSlideView.alpha = 1
                    }
                }
                selectedIndex = buttonIndex
                let selectorPosition = selectorWidth * CGFloat(buttonIndex)
                delegate?.changeToIndex(index: buttonIndex)
                UIView.animate(withDuration: 0.4) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
                btn.setTitleColor(selectedTextColor, for: .normal)
            }
        }
    }
    
    func setIndex(index : Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectedTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    convenience init(frame : CGRect , buttonTitle : [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    func updateButtonTitle(buttonTitles : [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

protocol CustomSegmentedControlDelegate: class {
    func changeToIndex(index : Int)
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
