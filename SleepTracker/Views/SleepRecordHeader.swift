//
//  SleepRecordHeader.swift
//  dummy
//
//  Created by Vikhyath on 20/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class SleepRecordHeader: UICollectionReusableView {

    @IBOutlet weak var openCloseButton: UIButton!
    @IBOutlet weak var totalSleepHourLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
