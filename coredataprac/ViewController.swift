//
//  ViewController.swift
//  coredataprac
//
//  Created by Rajpreet on 02/04/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {


        
    @IBOutlet weak var table: UITableView!
    
    var people: [NSManagedObject] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var addName: UIBarButtonItem!
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
      /*  let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.people.append(nameToSave)
                                        self.table.reloadData()
    }*/
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return;
            }
            self.save(name: nameToSave)
            self.table.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true)
    }


func save(name: String)
{
    //1
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    //2
    let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
    
    let person = NSManagedObject(entity: entity, insertInto: managedContext)
    
    //3
    person.setValue(name, forKeyPath: "name")
    
    //4
    do{
        try managedContext.save()
        people.append(person)
    }catch let error as NSError {
        print("Could not save \(error),\(error.userInfo)")
    }
    
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let person = people[indexPath.row]
            let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            //cell.textLabel?.text = person;
            cell.textLabel?.text =
                person.value(forKeyPath: "name") as? String
            return cell
        }
    }

