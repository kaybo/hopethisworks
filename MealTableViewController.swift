//
//  MealTableViewController.swift
//  Home
//
//  Created by vdy on 2018-06-29.
//  Copyright © 2018 Meal Mules. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    
    //Mark: Properties
    
    var meals = [Meal]()
    var filteredMeals = [Meal]()
    let searchController = UISearchController(searchResultsController: nil)
    
    //Returns true or false, true being search bar is empty, false being it is not empty
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //This function takes in whatever you type in from the search bar and compare it to all the meals in the list
    //This will then give the filtered version of the table
    //Reload data afterwards so that new filtered items appear whenever you type into the search bar
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMeals = meals.filter({( meal : Meal) -> Bool in
            return meal.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //Determines if you are filtering by checking the search bar and seeing if its empty
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    //Back button functionality.
    @objc func back(sender: UIBarButtonItem) {
        
        //Functionality
        
        //Hide the navigation bar again
        self.navigationController?.isNavigationBarHidden = true
        
        
        //This leads you back to the previous view controller.
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Hides the back button on navigation bar and implement your own.
        //This gives the back button more options, for example, you can do other things
        //when the back button is pressed.
        self.navigationItem.hidesBackButton = true
        let newButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MealTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newButton
        
        //Whenever this view is loaded, don't hide the navigation bar.
        self.navigationController?.isNavigationBarHidden = false
        
        //This loads all the sample meals and store them in the array
        loadSampleMeals()
        
        //Setup the Search Controller
        //Adds search bar functionality.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meals"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the amount of meals based on what you type on the search bar.
        if isFiltering() {
            return filteredMeals.count
        }
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        
        // Fetches the appropriate meal for the data source layout.
        var meal : Meal
        if isFiltering() {
            meal = filteredMeals[indexPath.row]
        } else {
            meal = meals[indexPath.row]
        }

        cell.foodName.text = meal.name

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //connect to table view
        
        guard let selectedMealCell = sender as? MealTableViewCell else {
            fatalError("Unexpected sender: (String(describing: sender))")
        }
        
        //Getting the selected recipe
        guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        var selectedMeal = Meal()
        if isFiltering(){
            selectedMeal = filteredMeals[indexPath.row]
        }
        else{
            selectedMeal = meals[indexPath.row]
        }
        
        let dest = segue.destination as! ViewController
       
        //Dest is the Home view. Change properties below
        dest.testMeal = selectedMeal
        
        
        

    }
 
    
    //This adds new meals into the array.
    //TODO:
    //For now, they are sample meals, but can import meals from database later
    private func loadSampleMeals() {
        
        let meal1 = Meal(name: "Caprese Salad")
        let meal2 = Meal(name: "Chicken and Potatoes")
        let meal3 = Meal(name: "Rice with Steak")
        let meal4 = Meal(name: "Apple pie")
        let meal5 = Meal(name: "Glass of milk")
        let meal6 = Meal(name: "Bacon")
            
        meals += [meal1, meal2, meal3,meal4,meal5,meal6]
 
    }

}

extension MealTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
