//
// Created by bowei xiao on 18.10.20.
//

import WatchConnectivity
import SpriteKit

protocol TouchHandleDelegate: class {
  func handleTouch(_ connection:SharedConnectivity, message: Double)
}
