//
//  PoweredByTapView.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 12/09/2023.
//

import UIKit
import TapFontKit_iOS

class PoweredByTapView: UIView {

    /// The view holding the back button
    var backView: UIView = .init(frame: .zero)
    /// The back button
    var backButton: UIButton = .init(frame: .zero)
    /// The back label
    var backLabel: UILabel = .init(frame: .zero)
    /// Indicating the back icon for the user
    var backIconImageView: UIImageView = .init(frame: .zero)
    /// Indicating the powered by tap icon for the user
    var poweredByTapImageView: UIImageView = .init(frame: .zero)
    /// Represents the main holding view
    var blurView: CardVisualEffectView = .init(frame: .zero)
    /// Represents the locale needed to render the powered by tap view with
    var selectedLocale:String = "en" {
        didSet{
            localize()
        }
    }
    /// A callback to do when the back button is clicked
    var backButtonClicked:()->() = {}
    
    //MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: - Private methods
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        setupConstraints()
        themeController()
        themeVisualEffectView()
        themeBackButton()
        themePoweredByTap()
        addBackButtonActionHandler()
        localize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Creates an event listener when clicking on the back button
    func addBackButtonActionHandler() {
        backButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        self.backButtonClicked()
    }
}

// MARK: - Theme based methods
extension PoweredByTapView {
    /// Theme the view level
    func themeController() {
        backgroundColor = .clear
    }
    
    /// Theme the blur view level
    func themeVisualEffectView() {
        // The background bluring effect
        blurView.scale = 1
        blurView.blurRadius = 6
        blurView.colorTint = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        blurView.colorTintAlpha = UIView().traitCollection.userInterfaceStyle == .dark ? 0.32 : 0.06
    }
    
    
    /// Theme the back button level
    func themeBackButton() {
        backIconImageView.image = .init(systemName: "chevron.backward")
        backIconImageView.tintColor = .white
        backLabel.textColor = .white
        backLabel.backgroundColor = .clear
        backView.backgroundColor = .clear
        backButton.backgroundColor = .clear
        backView.backgroundColor = .clear
    }
    
    /// Theme the back button level
    func themePoweredByTap() {
        poweredByTapImageView.image = UIImage(named: "Powered-by-tap",in: Bundle.currentBundle, with: nil)
        poweredByTapImageView.tintColor = .white
        poweredByTapImageView.contentMode = .scaleAspectFit
    }
    
    func setupConstraints() {
        backView.addSubview(backIconImageView)
        backView.addSubview(backLabel)
        backView.addSubview(backButton)
        addSubview(blurView)
        addSubview(poweredByTapImageView)
        addSubview(backView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
        backIconImageView.translatesAutoresizingMaskIntoConstraints = false
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        poweredByTapImageView.translatesAutoresizingMaskIntoConstraints = false
        poweredByTapImageView.tintColor = .white
        
        blurView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        poweredByTapImageView.snp.remakeConstraints { make in
            make.width.equalTo(112)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        
        backView.snp.remakeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(20)
            make.centerY.equalTo(poweredByTapImageView.snp.centerY)
            make.leading.equalToSuperview().offset(16)
        }
        
        backButton.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        backIconImageView.snp.remakeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        backLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(backIconImageView.snp.centerY)
            make.leading.equalTo(backIconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        DispatchQueue.main.async {
            self.blurView.setNeedsLayout()
            self.blurView.updateConstraints()
            
            self.poweredByTapImageView.setNeedsLayout()
            self.poweredByTapImageView.updateConstraints()
            
            self.backView.setNeedsLayout()
            self.backView.updateConstraints()
            
            self.backButton.setNeedsLayout()
            self.backButton.updateConstraints()
            
            self.backIconImageView.setNeedsLayout()
            self.backIconImageView.updateConstraints()
            
            self.backLabel.setNeedsLayout()
            self.backLabel.updateConstraints()
            
            self.setNeedsLayout()
            self.updateConstraints()
        }
        
    }
    
    /// Will change the direction of the language based uiviews/elements
    func localize() {
        DispatchQueue.main.async {
            self.semanticContentAttribute = self.selectedLocale.lowercased() == "ar" ? .forceRightToLeft : .forceLeftToRight
            self.backIconImageView.semanticContentAttribute = self.selectedLocale.lowercased() == "ar" ? .forceRightToLeft : .forceLeftToRight
            self.backView.semanticContentAttribute = self.selectedLocale.lowercased() == "ar" ? .forceRightToLeft : .forceLeftToRight
            self.backLabel.font = FontProvider.localizedFont(.robotoRegular, size: 16, languageIdentifier: self.selectedLocale.lowercased())
            self.backLabel.text = self.selectedLocale.lowercased() == "ar" ? "رجوع" : "Back"
            self.backLabel.semanticContentAttribute = self.selectedLocale.lowercased() == "ar" ? .forceRightToLeft : .forceLeftToRight
        }
    }
    
}
