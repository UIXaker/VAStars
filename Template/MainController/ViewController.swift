import UIKit

class ViewController: UIViewController {

    private var mainView: MainView { view as! MainView }
    override func loadView() { view = MainView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        mainView.addGestureRecognizer(gesture)
    }

    @objc private func viewDidTapped() {
        mainView.starsView.show(animated: true) { [weak self] in
            let conf: VAStarsConfiguration.FillType = .three(
                .init(hex: 0x1DB954),
                .init(hex: 0x1DB954),
                .init(hex: 0x1DB954)
            )
            
            self?.mainView.starsView.fillStars(fill: conf, animated: true, firstDelay: 0.3, delay: 0.15) {
                
            }
        }
    }
}

#Preview(traits: .portrait) {
    return ViewController()
}
