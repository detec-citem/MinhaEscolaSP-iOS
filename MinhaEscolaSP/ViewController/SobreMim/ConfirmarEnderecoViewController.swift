//
//  ConfirmarEnderecoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 07/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MapKit
import UIKit

final class ConfirmarEnderecoViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let distanciaMetros: Double = 500
        static let pinAnnotationView = "PinAnnotationView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var mapaView: MKMapView!
    
    //MARK: Variables
    weak var delegate: EnderecoLatitudeLongitudeDelegate!
    var latitude: Double!
    var longitude: Double!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordenadas = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapaView.setRegion(MKCoordinateRegion(center: coordenadas, latitudinalMeters: Constants.distanciaMetros, longitudinalMeters: Constants.distanciaMetros), animated: true)
        let marcador = MKPointAnnotation()
        marcador.coordinate = coordenadas
        if #available(iOS 11.0, *) {
            mapaView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: Constants.pinAnnotationView)
        }
        mapaView.addAnnotation(marcador)
    }
    
    //MARK: Actions
    @IBAction func confirmar(_ sender: Any) {
        delegate.editouLatitudeLongitude(latitude: latitude, longitude: longitude)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: MKMapViewDelegate
extension ConfirmarEnderecoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinAnnotationView: MKPinAnnotationView!
        if #available(iOS 11.0, *) {
            pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinAnnotationView, for: annotation) as? MKPinAnnotationView
        }
        else {
            pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinAnnotationView) as? MKPinAnnotationView
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.pinAnnotationView)
            }
        }
        pinAnnotationView.animatesDrop = true
        pinAnnotationView.isDraggable = true
        return pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending, let coordenadas = view.annotation?.coordinate {
            latitude = coordenadas.latitude
            longitude = coordenadas.longitude
        }
    }
}
