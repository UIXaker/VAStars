import UIKit

struct VAStarsConfiguration {
    var starSize: CGFloat = 40.0
    var borderColor: UIColor
    var defaultColor: UIColor
    
    enum FillType {
        case zero
        case one(UIColor)
        case two([UIColor])
        case three([UIColor])
    }
}

enum AnimationType: Equatable {
    case fade(duration: TimeInterval, deley: TimeInterval)
    case scale(duration: TimeInterval, factor: CGFloat)
    case none
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.fade, .fade), (.scale, .scale), (.none, .none): return true
        default: return false
        }
    }
}
