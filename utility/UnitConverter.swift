//
//  unitConversion.swift
//  Weather
//
//  Created by Juho on 8.12.2022.
//

import Foundation

struct unitConverter {
    func convertUnits(unit: Float, state:Int) -> Float {
        switch state{
        case 0:
            return unit
        case 1:
            return ((unit*1.8)+32)
        case 2:
            return (unit + 273.15)
        default:
            return 0
        }
    }
}
