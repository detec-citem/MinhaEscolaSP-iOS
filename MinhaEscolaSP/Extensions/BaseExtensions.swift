//
//  BaseExtensions.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

extension Date {
    var semTempo: Date {
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
}

extension DateFormatter {
    static let defaultDateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    static let isoDateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension NumberFormatter {
    static let notaFormatter = { () -> NumberFormatter in
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.decimalSeparator = ","
        return numberFormatter
    }()
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}

extension UITableView {
    func dequeue<T: UITableViewCell>(index: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.className, for: index) as! T
    }
}

extension UITableViewCell {
    class func register(_ tableView: UITableView) {
        tableView.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
}
