//
//  UILabel+Extension.swift
//  VKClient
//
//  Created by Павел on 12.04.2024.
//

import UIKit

extension UILabel {
    func getTextSize() -> CGSize {
        guard let text else { return CGSize() }
        let fontName = font.fontName
        let fontSize = font.pointSize
        let font = UIFont(name: fontName, size: fontSize)
        let fontAttributes = [NSAttributedString.Key.font : font]
        let size = text.size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: size.width.rounded(),
                      height: size.height.rounded())
    }
    
    func textErrorAnimation() {
        let baseTextColor = textColor

        UIView.animate(withDuration: 0.1) {
            self.textColor = .vkRed
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                UIView.animate(withDuration: 0.1) {
                    self.textColor = baseTextColor
                }
            }
        }
    }
}
