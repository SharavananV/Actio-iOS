//
//  CustomImageView.swift
//  Actio
//
//  Created by senthil on 07/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
 class MyCustomImageView : UIImageView{

    var myId : String = "";
    override init(frame: CGRect){
        super.init(frame: frame);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
