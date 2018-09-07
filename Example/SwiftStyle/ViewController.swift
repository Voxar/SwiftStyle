//
//  ViewController.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 08/30/2018.
//  Copyright (c) 2018 Patrik Sjöberg. All rights reserved.
//

import UIKit
import SwiftStyle

let MyStyle = Style { s in
    s.backgroundColor = UIColor(white: 0.8, alpha: 1)
    s.font = UIFont.boldSystemFont(ofSize: 20)
    
    s.style("selected") { s in
        s.foregroundColor = .blue
    }
    
    s.style("green") { s in
        s.foregroundColor = .green
        s.backgroundColor = .blue
    }
    
    s.style("blue") { s in
        s.foregroundColor = .blue
        s.backgroundColor = .green
        
//        s.when(.focused) { s in
//            s.inherits("selected")
//        }
    }
    
    s.style("extended green") { s in
        s.inherits("green")
        s.fontSize = 12
    }
    
    s.style("extended blue") { s in
        s.inherits("blue")
        s.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
    
    s.style("button 1") { s in
        s.foregroundColor = .red
//        s.fontSize = 12
        s.fontName = "Courier"
    }
    
    s.style("button 2") { s in
        s.backgroundColor = UIColor.green.withAlphaComponent(0.8)
        s.cornerRadius = 14
        s.borderColor = UIColor.blue.withAlphaComponent(0.8)
        s.borderWidth = 2
        s.foregroundColor = UIColor.blue
        
        s.when(.highlighted) { s in
            s.borderColor = UIColor.white.withAlphaComponent(0.8)
            s.foregroundColor = UIColor.red
        }
    }
    
    s.style("stack") { s in
        s.style("3") { s in
            s.backgroundColor = .magenta
        }
        s.style("stack 2") { s in
            s.style("1") { s in
                s.backgroundColor = .red
            }
            s.style("2") { s in
                s.backgroundColor = .green
            }
            s.style("3") { s in
                s.backgroundColor = .blue
            }
        }
        s.style("1") { s in
            s.backgroundColor = .orange
        }
        s.style("2") { s in
            s.backgroundColor = .purple
        }
        
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyStyle.apply(to: view)
    }

}

