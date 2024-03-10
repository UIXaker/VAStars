import UIKit

class MainView: UIView {
    
    let starsView: VAStars = {
        let configuration = VAStarsConfiguration(
            borderColor: .init(hex: 0x929292),
            defaultColor: .init(hex: 0x929292),
            animationType: .fade(duration: 0.3, deley: 0.15)
        )
        
       return VAStars(configuration: configuration)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: 0x252525)
        
        addSubview(starsView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        starsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            starsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
