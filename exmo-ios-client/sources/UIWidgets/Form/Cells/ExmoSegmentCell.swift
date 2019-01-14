//
// Created by Bogdan Sasko on 1/6/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoSegmentCell: UITableViewCell, SegmentFormConformity {
    var formItem: SegmentFormItem?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .bold, fontSize: 14)
        return label
    }()

    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [])
        sc.tintColor = .dark
        return sc
    }()

    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = nil
        selectionStyle = .none
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't have implementation")
    }

    @objc func onValueChanged(_ sender: UISegmentedControl) {
        let normalColor = sender.selectedSegmentIndex == 0 ? UIColor.orangePink : UIColor.greenBlue
        let selectedColor = sender.selectedSegmentIndex == 0 ? UIColor.greenBlue : UIColor.orangePink

        sender.setTitleTextAttributes(
                [ NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .bold, fontSize: 12),
                  NSAttributedString.Key.foregroundColor: normalColor ],
                for: .normal
        )
        sender.setTitleTextAttributes(
                [ NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .bold, fontSize: 12),
                  NSAttributedString.Key.foregroundColor: selectedColor ],
                for: .selected
        )
        formItem?.onChange?(sender.selectedSegmentIndex)
    }
}

extension ExmoSegmentCell {
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor,
                          bottom: nil, right: self.rightAnchor,
                          topConstant: 0, leftConstant: 30,
                          bottomConstant: 0, rightConstant: 30,
                          widthConstant: 0, heightConstant: 0)

        addSubview(segmentControl)
        segmentControl.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor,
                              bottom: nil, right: titleLabel.rightAnchor,
                              topConstant: 20, leftConstant: 0,
                              bottomConstant: 0, rightConstant: 0,
                              widthConstant: 0, heightConstant: 0)
        segmentControl.addTarget(self, action: #selector(onValueChanged(_:)), for: .valueChanged)
        segmentControl.sendActions(for: .valueChanged)

        addSubview(separatorHLineView)
        separatorHLineView.anchor(nil, left: self.leftAnchor,
                                  bottom: self.bottomAnchor, right: self.rightAnchor,
                                  topConstant: 0, leftConstant: 30,
                                  bottomConstant: 0, rightConstant: 30,
                                  widthConstant: 0, heightConstant: 1)
    }
}


extension ExmoSegmentCell: FormUpdatable {
    func update(item: FormItem?) {
        guard let fi = item as? SegmentFormItem,
              let uiProperties = fi.uiProperties as? SwitchCellUIProperties else { return }
        formItem = fi
        titleLabel.text = fi.title
        titleLabel.textColor = uiProperties.titleColor

        if fi.sections.count == segmentControl.numberOfSegments {
            for sectionIdx in (0..<fi.sections.count) {
                segmentControl.setTitle(fi.sections[sectionIdx], forSegmentAt: sectionIdx)
            }
        } else {
            segmentControl.removeAllSegments()
            for sectionIdx in (0..<fi.sections.count) {
                segmentControl.insertSegment(withTitle: fi.sections[sectionIdx], at: sectionIdx, animated: false)
            }
        }

        segmentControl.selectedSegmentIndex = 0
        segmentControl.sendActions(for: .valueChanged)
    }
}
