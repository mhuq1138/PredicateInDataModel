//
//  DisplayViewController.swift
//  FetchRequestInFourWays
//
//  Created by Mazharul Huq on 2/24/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class DisplayViewController: UITableViewController {
    @IBOutlet var predicateLabel: UILabel!
    
    var coreDataStack:CoreDataStack!
    
    var fetchOption = 0
    var countries:[Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataStack = CoreDataStack(modelName: "CountryList")
    
        self.tableView.rowHeight = 80.0
        let fetchString = getFetchString(fetchOption)
        self.predicateLabel.text = fetchString
        guard let model =
            coreDataStack.managedContext
                .persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model
                .fetchRequestTemplate(forName: fetchString)
                as? NSFetchRequest<Country> else {
                    return
        }
        
        do{
            countries = try self.coreDataStack.managedContext.fetch(fetchRequest)
        }
        catch
            let nserror  as NSError{
                print("Could not save \(nserror),(nserror.userInfo)")
        }

    }
    
    
    func getFetchString(_ option:Int)-> String{
        var fetchString = ""
        switch fetchOption {
        case 0:
            fetchString = "CapitalFetchRequest"
        case 1:
            fetchString = "NameFetchRequest"
        case 2:
            fetchString = "AreaFetchRequest"
        case 3:
            fetchString = "PopulationFetchRequest"
        case 4:
            fetchString = "NameAndPopulationFetchRequest"
        default:
            break
        }
        return fetchString
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        var nameString = ""
        var capitalString = ""
        
        if let name = country.name{
            nameString = name
        }
        if let capital = country.capital{
            capitalString = "Capital: \(capital)"
        }

        cell.textLabel?.text = nameString + " " + capitalString
        cell.detailTextLabel?.text = """
        Area: \(country.area) sq mi
        Population: \(country.population) millions
        """
        return cell
    }
}
