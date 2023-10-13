//
//  MapViewController.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets and properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityLoadingIndicator: UIActivityIndicatorView!
    
    var mapLocations = [StudentInformation]()
    var pinAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
        activityLoadingIndicator.hidesWhenStopped = true
    }
    
    // MARK: Refresh map
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        getStudentsPins()
    }
    
    // MARK: Logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.activityLoadingIndicator.startAnimating()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityLoadingIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Data source for MapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
    
    // MARK: Add map annotations
    func getStudentsPins() {
        self.activityLoadingIndicator.startAnimating()
        UdacityClient.getStudentLocations() { locations, error in
            if error != nil {
                self.showAlert(message: error?.localizedDescription ?? "", title: "Login Error")
            }
            
            self.mapView.removeAnnotations(self.pinAnnotations)
            self.pinAnnotations.removeAll()
            self.mapLocations = locations ?? []
            
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                self.pinAnnotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.pinAnnotations)
                self.activityLoadingIndicator.stopAnimating()
            }
        }
    }
}
