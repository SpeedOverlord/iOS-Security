//
//  MenuTableViewCell.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import UIKit

protocol MenuModel: AnyObject {
    func configure(with text: String)
}

class MenuTableViewCell: UITableViewCell, MenuModel {

    private var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.sizeToFit()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(with text: String) {
        layoutView()
        configureView()
        title = text
    }
    
    private func layoutView() {
        self.addSubview(titleLabel)
    }
    
    private func configureView() {
        NSLayoutConstraint.addConstraints(titleLabel, toView: self, withConstants: [10, -10, 10, -10])

    }
}
