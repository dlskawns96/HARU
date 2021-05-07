//
//  LinedTextView.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/12.
//

import UIKit

class LinedTextView: UITextView {
    
    var attributes: [NSAttributedString.Key: Any]?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.addDoneButton()
        self.backgroundColor = .clear
        let fontSize = self.bounds.width / 20.0
        self.font = UIFont.systemFont(ofSize: fontSize)
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 50.0
        style.minimumLineHeight = 50.0
        
        self.attributes = [
            .paragraphStyle: style,
            .font: font
        ]
        
        self.attributedText = NSAttributedString(string: "", attributes: attributes)
        self.typingAttributes = attributes!
        func draw(_ rect: CGRect) {
            
        }
    }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Get the current drawing context
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // Set the line color and width
        context.setStrokeColor(UIColor(named: AppDelegate.MAIN_COLOR)!.cgColor)
        context.setLineWidth(1.0);
        
        // Start a new Path
        context.beginPath()
        
        //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
        //        let numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font!.lineHeight
        let numberOfLines = 20
        
        // Set the line offset from the baseline.
        let baselineOffset: CGFloat = (self.font?.pointSize)! / 2.0
        
        let style = self.attributes![.paragraphStyle] as! NSMutableParagraphStyle
        // Iterate over numberOfLines and draw a line in the textView
        for x in 1..<Int(numberOfLines) {
            //0.5f offset lines up line with pixel boundary
            
            context.move(to: CGPoint(x: self.bounds.origin.x, y: style.minimumLineHeight * CGFloat(x) + baselineOffset))
            context.addLine(to: CGPoint(x: CGFloat(self.bounds.size.width), y: style.minimumLineHeight * CGFloat(x) + baselineOffset))
            
        }
        
        //Close our Path and Stroke (draw) it
        context.closePath()
        context.strokePath()
    }
}
