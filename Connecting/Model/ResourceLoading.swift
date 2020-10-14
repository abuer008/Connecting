//
//  ResourceLoading.swift
//  Connecting
//
//  Created by bowei xiao on 03.10.20.
//

protocol ResourceLoading: class {
    
    func loadResources(withCompletionHandler completionHandler: @escaping () -> ())
}
