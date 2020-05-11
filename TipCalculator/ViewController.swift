//
//  ViewController.swift
//  TipCalculator
//
//  Created by Tomona Sako on 2020/05/08.
//  Copyright © 2020 Tomona Sako. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    private let scrollView =  UIScrollView()
    
    private let billAmountTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Bill Amount"
        let rgba = CGColor.init(srgbRed: 6/255, green: 214/255, blue: 160/255, alpha: 1.0)
        tf.layer.borderColor = rgba
        tf.layer.borderWidth = 1
        tf.minimumFontSize = 30
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        
        return tf
    }()
    
    private var tipAmountLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "$ 0.00"
        lb.font = UIFont.boldSystemFont(ofSize: 50)
        return lb
    }()
    
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Amount"
        return label
    }()
    
    private let tipPercentageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Amount"
        return label
    }()
    
    private var percentageLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "13 %"
        lb.adjustsFontSizeToFitWidth = true
        lb.textAlignment = .center
        return lb
    }()
    
    private let calcButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Calculate Tip", for: .normal)
        btn.backgroundColor = UIColor(red: 6/255, green: 214/255, blue: 160/255, alpha: 1.0)
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    let adjustTipPercentage : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.value = 13
        slider.maximumTrackTintColor = UIColor(red: 27/255, green: 154/255, blue: 170/255, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor(red: 239/255, green: 71/255, blue: 111/255, alpha: 1.0)
        slider.widthAnchor.constraint(equalToConstant: 300).isActive = true
        slider.addTarget(self, action: #selector(changeLabel), for: .valueChanged)
        slider.addTarget(self, action: #selector(calcTip), for: .valueChanged)
        //        slider.thumbTintColor = UIColor(red: 255/255, green: 196/255, blue: 61/255, alpha: 1.0)
        return slider
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.billAmountTextField.delegate = self
        
        //        registerForKeyboardNotification()
        setup()
        
    }
    
    private func setup() {
        view.backgroundColor = UIColor(red: 242/255, green: 248/255, blue: 245/255, alpha: 1.0)
        
        
        //        scrollView.isScrollEnabled = true
        //        scrollView.showsVerticalScrollIndicator = true
        //        sv.translatesAutoresizingMaskIntoConstraints = false
        //        scrollView.delegate = self
        //        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        //        view.addSubview(scrollView)
        
        let vStackView = UIStackView(arrangedSubviews: [tipAmountLabel, totalLabel, billAmountTextField, tipPercentageLabel, adjustTipPercentage, percentageLabel, calcButton])
        vStackView.axis = .vertical
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.alignment = .center
        vStackView.distribution = .fillEqually
        vStackView.spacing = 20
        //        scrollView.addSubview(vStackView)
        view.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            //            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            billAmountTextField.leftAnchor.constraint(equalTo: vStackView.leftAnchor),
            billAmountTextField.rightAnchor.constraint(equalTo: vStackView.rightAnchor),
            percentageLabel.leftAnchor.constraint(equalTo: vStackView.leftAnchor),
            percentageLabel.rightAnchor.constraint(equalTo: vStackView.rightAnchor),
        ])
    }
    
    //    private func registerForKeyboardNotification() {
    //      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    //      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    //    }
    //
    //    @objc func keyboardWasShown(_ notification: Notification) {
    //      // 1. get the size of the keyboard
    //      guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
    //      let keyboardHeight = keyboardFrame.cgRectValue.size.height
    //      // 2. scroll scrollview's content up
    //      let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    //      scrollView.contentInset = contentInsets
    //      scrollView.scrollIndicatorInsets = contentInsets
    //    }
    //
    //    @objc func keyboardWillBeHidden(_ notification: Notification) {
    //      scrollView.contentInset = UIEdgeInsets.zero
    //      scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    //    }
    //
    @objc private func changeLabel(_ sender: UISlider!) {
        let tipRate = floor(Double(sender.value))
        percentageLabel.text = String(format: "%.0f", tipRate) + " %"
    }
    
    @objc private func calcTip(_ sender: UISlider!){
        guard billAmountTextField.text != nil else {
            return
        }
        let tipRate = floor(Double(sender.value)) / 100
        if let amountBill = billAmountTextField.text {
            let tip = atof(amountBill) * tipRate
            tipAmountLabel.text = String(format: "$ %.2f", tip)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //    @objc private func calcTip(_ sender: UIButton!){
    //        guard billAmountTextField.text != nil else {
    //            return
    //        }
    //        let tipRate = floor(Double(adjustTipPercentage.value)) / 100
    //        if let amountBill = billAmountTextField.text {
    //            let tip = atof(amountBill) * tipRate
    //            tipAmountLabel.text = String(format: "$ %.2f", tip)
    //        }
    //    }
}

