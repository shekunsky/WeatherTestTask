//
//  TableView.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class TableView: UITableView {
    open override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}

class CollectionView: UICollectionView {
    open override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}

