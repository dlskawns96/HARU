//
//  LocationTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/18.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        configureCell()
    }
    
    private func configureCell() {
        guard let geo = EventDetailViewController.event.structuredLocation?.geoLocation else {
            mapView.removeFromSuperview()
            return
        }
        
        mapView.mapType = .standard
        mapView.isUserInteractionEnabled = false
        mapView.centerToLocation(geo)
        let annotation = MKPointAnnotation()
        annotation.title = EventDetailViewController.event.structuredLocation?.title
        annotation.coordinate = geo.coordinate
        mapView.addAnnotation(annotation)
    }

}
