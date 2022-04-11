//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Gabriel Zempoalteca Garrido on 10/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!

    // Reference to managedObject context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Data for the table
    var items: [Person]?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        fetchPeople()
    }

    // MARK: - Functions

    func fetchPeople() {
        do {
            self.items = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error: \(error), \(error.localizedDescription)")
        }
    }

    // MARK: - Actions

    @IBAction func addTapped(_ sender: Any) {
        // Create alert
        let alert = UIAlertController(title: "Add person",
                                      message: "What is their name?",
                                      preferredStyle: .alert)
        alert.addTextField()

        // Create button handler
        let submitButton = UIAlertAction(title: "Add",
                                         style: .default) { action in
            // Get the textfiled for the alert
            let textField = alert.textFields![0]

            // Create a new person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 10
            newPerson.gender = "Male"

            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Error: \(error), \(error.localizedDescription)")
            }

            // Re-fetch the data
            self.fetchPeople()

        }
        // Add button
        alert.addAction(submitButton)
        // Show Alert
        self.present(alert, animated: true)
    }

}
// MARK: Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select person
        let person = self.items![indexPath.row]

        // Create alert
        let alert = UIAlertController(title: "Edit person",
                                      message: "Edit name:",
                                      preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields![0]
        textField.text = person.name

        // Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in

            // Get the textfield for the alert
            let textfield = alert.textFields![0]

            // Edit name property of person object
            person.name = textField.text

            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Error: \(error), \(error.localizedDescription)")
            }

            // Re-fetch the data
            self.fetchPeople()

        }
        // Add button
        alert.addAction(saveButton)
        // Show Alert
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // Create Swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let personToRemove = self.items![indexPath.row]

            // Remove the person
            self.context.delete(personToRemove)

            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Error: \(error), \(error.localizedDescription)")
            }
            self.fetchPeople()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }

}
