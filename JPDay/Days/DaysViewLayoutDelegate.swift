//
//  DaysViewLayoutDelegate.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

public protocol DaysViewLayoutDelegate: UICollectionViewDelegate {

    func numberOfColumnsInDaysViewLayout(_ layout: DaysViewLayout) -> Int

}
