//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Basith on 20/01/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    var people: [NSManagedObject] = []
    
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var emailfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateAction(_ sender: Any) {
        update(email: emailfield.text!, name: namefield.text!)
    }
    
    @IBAction func deletAction(_ sender: Any) {
        self.deletes(email: emailfield.text!)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.clear()
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        if namefield.text != "" && emailfield.text != "" {
            self.save(name: namefield.text!, email: emailfield.text!)
        }
        namefield.text = ""
        emailfield.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showData()
    }
    
    func showData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
//        fetchRequest.predicate = NSPredicate(format: "name == %@", "basith")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        myLabel.text = ""
        
        for data in people{
            guard let name = data.value(forKey: "name") as? String, let email = data.value(forKey: "email") as? String else {
                continue
            }
            myLabel.text = myLabel.text! + "\n email : " + email + "\n name : " + name
        }
    }
 
    
    
    func save(name: String, email : String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User",in: managedContext)!
        let person = NSManagedObject(entity: entity,insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        person.setValue(email, forKeyPath: "email")
        do {
            try managedContext.save()
            people.append(person)
            self.showData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func update(email : String, name : String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do{
            let object = try managedContext.fetch(fetchRequest)
            if object.count == 1{
                if let objectUpdate = object.first as? NSManagedObject {
                    objectUpdate.setValue(name, forKey: "name")
                    do{
                        try managedContext.save()
                        showData()
                    }
                    catch {
                        print(error)
                    }
                }
                
            }
        }
        catch {
            print(error)
        }
    }
    
    func deletes(email : String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSManagedObject>(entityName: "User")
        deleteFetch.predicate = NSPredicate(format: "email == %@", email)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            showData()
        } catch {
            print ("There was an error")
        }
    }
    
    func clear(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext        
        let deleteFetch = NSFetchRequest<NSManagedObject>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            showData()
        } catch {
            print ("There was an error")
        }
    }
    
    
}

