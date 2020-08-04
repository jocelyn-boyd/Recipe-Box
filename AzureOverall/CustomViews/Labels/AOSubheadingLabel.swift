//
//  SubheadingLabel.swift
//  AzureOverall
//
//  Created by Jocelyn Boyd on 8/3/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class AOSubheadingLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
  }
  
  
  func configure() {
  textColor = UIColor(displayP3Red: 83 / 255, green: 179 / 255, blue: 203 / 255, alpha: 1)
  numberOfLines = 0
  lineBreakMode = .byWordWrapping
  translatesAutoresizingMaskIntoConstraints = false
  }
}