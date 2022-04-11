//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Gabriel Zempoalteca Garrido on 10/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Access to persistent container
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let container = delegate.persistentContainer
            let managedObjectContext = container.viewContext
            
        }

    }

}
