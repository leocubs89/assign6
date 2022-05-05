//
//  Album+ViewModel.swift
//  assign6
//
//  Created by Leo Lopez on 5/4/22.
//

import Foundation
import UIKit

extension Album {
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    var showYear: String {
        return String(year)
    }
    
    var showArtist: String {
        return artist?.name ?? "Undefined"
    }

    var showThumbnail: UIImage {
        if let data = thumbnail, let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "nopicture")!
        }
    }

    var showCover: UIImage {
        if let data = cover, let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "nopicture")!
        }
    }
}
