//
//  RouteTableViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/18/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RouteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - var and let
    var dataManager: DataManager!
    private var selectedDepartureFetchedController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext {
        return appDelegate.managedObjectContext
    }
    private var selectedDepartureStation: SelectedDepartureStation!
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var departureStationOutlet: UITableViewCell!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        dataManager = DataManager()
        dataManager.saveData(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setSetting()
        setFetchedResultsControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    private func tableViewOpensController(index: NSIndexPath) {
        switch index {
        case NSIndexPath(forRow: 0, inSection: 0):
            performSegueWithIdentifier("showDepartureTVC", sender: self)
        case NSIndexPath(forRow: 0, inSection: 1):
            performSegueWithIdentifier("showHostTVC", sender: self)
        case NSIndexPath(forRow: 0, inSection: 2):
            break
        default: break
        }
    }
    
    // MARK: - functions
    private func setSetting() {
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - getting data of selected stations
    private func setFetchedResultsControllers() {
        selectedDepartureFetchedController = NSFetchedResultsController(fetchRequest: departureFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedDepartureFetchedController.delegate = self
        do {
            try selectedDepartureFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.localizedDescription)
        }
        if selectedDepartureFetchedController.fetchedObjects?.first != nil {
            selectedDepartureStation = selectedDepartureFetchedController.fetchedObjects!.first as! SelectedDepartureStation
            guard let stationTitle = selectedDepartureStation.stationTitle else { return }
            departureStationOutlet.textLabel?.text = stationTitle
        } else {
            departureStationOutlet.textLabel?.text = "Откуда?"
        }
    }
    
    private func departureFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

// MARK: - Table delegate

extension RouteTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableViewOpensController(indexPath)
    }
}
