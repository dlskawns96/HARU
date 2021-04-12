//
//  LinedTextView.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/12.
//

import UIKit

class LinedTextView: UITextView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Make the textView's borders round
//        let borderColor : UIColor = UIColor(red: 0.50, green: 0.25, blue: 0.00, alpha: 1.00)
//        self.layer.borderColor = borderColor.cgColor
//        self.layer.borderWidth = 0.6
//        self.layer.cornerRadius = 5.0
        
        // Set some properties of the textView
        self.backgroundColor = .white
        let fontSize = self.bounds.width / 10.0
        self.font = UIFont.systemFont(ofSize: fontSize)
                
        func draw(_ rect: CGRect) {
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Get the current drawing context
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // Set the line color and width
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1.0);
        
        // Start a new Path
        context.beginPath()
        
        //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
        let numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font!.lineHeight
        
        // Set the line offset from the baseline.
        let baselineOffset:CGFloat = 10.0
        
        // Iterate over numberOfLines and draw a line in the textView
        for x in 1..<Int(numberOfLines) {
            //0.5f offset lines up line with pixel boundary
            
            context.move(to: CGPoint(x: self.bounds.origin.x, y: self.font!.lineHeight * CGFloat(x) + baselineOffset))
            context.addLine(to: CGPoint(x: CGFloat(self.bounds.size.width), y: self.font!.lineHeight * CGFloat(x) + baselineOffset))
            
        }
        
        //Close our Path and Stroke (draw) it
        context.closePath()
        context.strokePath()
    }
}
