//
//  String+Validations.swift
//  AzureOverall
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation

extension String {
  var isValidEmail: Bool {
    // this pattern requires that an email use the following format:
    // [something]@[some domain].[some tld]
    let validEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", validEmailRegEx)
    return emailPredicate.evaluate(with: self)
  }
}
