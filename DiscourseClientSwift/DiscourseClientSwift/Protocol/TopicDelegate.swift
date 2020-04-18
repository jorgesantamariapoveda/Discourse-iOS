//
//  TopicDelegate.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 24/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

protocol TopicDelegate {
    /*
     No tiene gran importancia pero, un método delegado no debería decir a su implementador "qué hacer",
     sino más bien le tiene que decir lo que "ha pasado".
     */
    func reloadLatestTopics()
    
}
