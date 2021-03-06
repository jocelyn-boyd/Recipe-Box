//
//  Constants.swift
//  AzureOverall
//
//  Created by Jocelyn Boyd on 8/29/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

struct Constants {
  
  struct SetTitle {
    static let AppName = "Recipe Box"    
    static let username = "Username"
    static let email = "Email"
    static let password = "Password"
    static let login = "Login"
    static let signup = "Sign Up"
  }
  
  // MARK: - ToDO: Refactor Color Palette for color-blind users
  struct AppColorPalette {
    
    // Half Opacity
    static let uaRedHalfOpacity = UIColor(red: 224 / 255, green: 26 / 255, blue: 79 / 255, alpha: 0.5)
    static let fireOpalHalfOpacity = UIColor(red: 241 / 255, green: 89 / 255, blue: 70 / 255, alpha: 0.5)
    static let orangeYellowHalfOpacity = UIColor(red: 249 / 255, green: 194 / 255, blue: 46 / 255, alpha: 0.5)
    static let maximumBlueHalfOpacity = UIColor(red: 83 / 255, green: 179 / 255, blue: 203 / 255, alpha: 0.5)
  }
}
