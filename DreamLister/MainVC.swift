//
//  ViewController.swift
//  DreamLister
//
//  Created by Allan Edwards on 5/8/17.
//  Copyright © 2017 Allan Edwards. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    var controller: NSFetchedResultsController<Item>!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //deleteTestData()
        //generateTestData()
        generateStoreList()
        
        attemptFetch()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        // update cell
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
        
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
        
    }
    
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        if segment.selectedSegmentIndex == 0 {
        fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
                
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
               configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
            
        }
    }
    
    func generateStoreList() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            if result.count < 1 {
                
            
            let store = Store(context: context)
            store.name = "Best Buy"
            let store2 = Store(context: context)
            store2.name = "Tesla Dealer"
            let store3 = Store(context: context)
            store3.name = "Apple Store"
            let store4 = Store(context: context)
            store4.name = "Target"
            let store5 = Store(context: context)
            store5.name = "Amazon"
            let store6 = Store(context: context)
            store6.name = "Radio Shack"
            ad.saveContext()
            }
            }
        }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "Tesla Model S"
        item.details = "For me and for the planet"
        item.price = 110000
        
        let item2 = Item(context: context)
        item2.title = "Amazon Echo Show"
        item2.details = "It has a screen. Does it need a screen?"
        item2.price = 280
        
        let item3 = Item(context: context)
        item3.title = "iPad 128 GB"
        item3.details = "I mean, it's nicer than a Kindle Fire"
        item3.price = 400
        ad.saveContext()
    }
    func deleteStoreList() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
    }
    func deleteTestData() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
    }
    
    

}

