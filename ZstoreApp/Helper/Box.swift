//
//  Box.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import Foundation


class Box<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}


enum LoadState {
    case loading
    case populated
    case error
}

