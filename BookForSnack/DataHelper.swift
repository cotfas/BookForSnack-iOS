//
//  DataHelper.swift
//  BookForSnack
//
//  Created by WORK on 02/02/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit
import CoreData

protocol IDataHelper {
    func getTableView() -> UITableView
    func updateData(_ array: [Restaurant])
}

public class DataHelper : NSObject, NSFetchedResultsControllerDelegate{
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var delegate: IDataHelper!
    
    internal override init(){} // Avoiding instantiation
    
    func setup(_ delegate: IDataHelper!) {
        self.delegate = delegate
        self.delegate.updateData(fetch())
    }
    
    public static func getFromDatabase() -> [Restaurant] {
        var restaurants: [Restaurant] = []
        
        if let context = AppDelegate.getDatabaseContext() {
            let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            
            do {
                // Fetching data from dataBase
                let all = try context.fetch(request)
                restaurants = all
        
            } catch {
                print(error)
            }
        }
        
        return restaurants
    }
    
    private func fetch() -> [Restaurant] {
        
        var restaurants: [Restaurant] = []
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "restaurantName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = AppDelegate.getDatabaseContext() {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        return restaurants
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        let tableView = delegate.getTableView()
        
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let tableView = delegate.getTableView()
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            let restaurants = fetchedObjects as! [Restaurant]
            delegate.updateData(restaurants)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        let tableView = delegate.getTableView()
        
        tableView.endUpdates()
    }
}
