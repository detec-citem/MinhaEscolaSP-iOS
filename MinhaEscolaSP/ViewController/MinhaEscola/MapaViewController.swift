//
//  MapaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 18/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

final class MapaViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let distancia: Double = 625
        static let escolaAnnotationView = "EscolaAnnotationView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    //MARK: Variables
    fileprivate var coordenadas: CLLocationCoordinate2D!
    fileprivate var regiao: MKCoordinateRegion!
    var latitude: Double!
    var longitude: Double!
    var nome: String!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coordenadas = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: Constants.distancia, longitudinalMeters: Constants.distancia)
        mapView.setRegion(regiao, animated: true)
        let annotation = MKPointAnnotation()
        annotation.subtitle = nome
        annotation.coordinate = coordenadas
        if #available(iOS 11.0, *) {
            mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: Constants.escolaAnnotationView)
        }
        mapView.addAnnotation(annotation)
    }
    
    //MARK: Actions
    @IBAction func abrirMapas(_ sender: Any) {
        let placemark = MKPlacemark(coordinate: coordenadas, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = nome
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regiao.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regiao.span)])
    }
}

//MARK: MKMapViewDelegate
extension MapaViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.escolaAnnotationView, for: annotation)
            pinAnnotationView.annotation = annotation
            return pinAnnotationView
        }
        else if let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.escolaAnnotationView) as? MKPinAnnotationView {
            pinAnnotationView.annotation = annotation
            return pinAnnotationView
        }
        else {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.escolaAnnotationView)
            return pinAnnotationView
        }
    }
}
