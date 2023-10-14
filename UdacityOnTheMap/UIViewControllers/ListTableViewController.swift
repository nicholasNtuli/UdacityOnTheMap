//
//  ListTableViewController.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import UIKit

class ListTableViewController: UITableViewController {

    @IBOutlet weak var studentTableView: UITableView!
    
    var activityLoadinIndicator: UIActivityIndicatorView!
    var students = [StudentInformation]()
    
    override func viewDidLoad() {
        activityLoadinIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.gray)
        self.view.addSubview(activityLoadinIndicator)
        activityLoadinIndicator.bringSubviewToFront(self.view)
        activityLoadinIndicator.center = self.view.center
        showActivityIndicator()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    // MARK: Refresh list
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    // MARK: Logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        showActivityIndicator()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator()
            }
        }
    }
    
    // MARK: Student List
    func getStudentsList() {
        showActivityIndicator()
        UdacityClient.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }

    // MARK: Data source for the Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.studentTableViewCellIdentifier, for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: Hide and Show Activity Loading Indicator Functions
    func hideActivityIndicator() {
        activityLoadinIndicator.stopAnimating()
        activityLoadinIndicator.isHidden = true
    }
 
    func showActivityIndicator() {
        activityLoadinIndicator.isHidden = false
        activityLoadinIndicator.startAnimating()
    }
    
    
}
