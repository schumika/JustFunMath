//
//  ComputationViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class ComputationViewController: ExerciseViewController {
    @IBOutlet weak var digitsStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.collectionViewLayout = layout
            self.collectionView.register(ComputationCollectionViewCell.self, forCellWithReuseIdentifier: "ComputationCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadDigits()
        self.configureBoard()
    }
    

    var computationsCompleted: Bool = false {
        didSet {
            self.doneButton.isEnabled = self.computationsCompleted
        }
    }
    var computations: [Computation] = []

    var allDigitLabels: [RoundLabelView] = []

    func configureBoard() {
        self.computationsCompleted = false
        self.computations = ComputationGenerator.generateComputations(count: 2)
        self.collectionView.reloadData()
    }
    
    private func loadDigits() {
        self.allDigitLabels.removeAll()

        for (ind1, substack) in self.digitsStack.arrangedSubviews.enumerated() {
            guard let subviews = (substack as? UIStackView)?.arrangedSubviews else { return }
            for (ind2, subview) in  subviews.enumerated() {
                
            guard let roundLabelView = subview as? RoundLabelView else { return }
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

            roundLabelView.configure(with: "\((ind1 == 0 ? 0 : 5) + ind2)", panGestureRecognizer: panGestureRecognizer)
            allDigitLabels.append(roundLabelView)
            }
        }
    }
    
    private func computationViews() -> [ComputationView] {
        var computationViews: [ComputationView] = []
        for cell in self.collectionView.visibleCells.compactMap({ $0 as? ComputationCollectionViewCell }) {
            computationViews.append(cell.computationView)
        }
        
        return computationViews
    }

    var panTrackingPoint = CGPoint.zero
    var panStartingPoint = CGPoint.zero
    var selectedView: RoundLabelView?

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let movingLabel = recognizer.view as? TouchableLabel else { return }

        let allSubviews = self.allDigitLabels
        let resultLabels = self.computationViews().compactMap { $0.resultLabel }

        switch recognizer.state {
        case .began:
            self.panTrackingPoint = movingLabel.center
            self.panStartingPoint = movingLabel.center

            movingLabel.isMoving = true
            self.selectedView = allSubviews.first { $0.label.isMoving == true }

        case .changed:
            let translation = recognizer.translation(in: self.view)
            let panOffsetTransform = CGAffineTransform( translationX: translation.x, y: translation.y)

            movingLabel.center = self.panTrackingPoint.applying(panOffsetTransform)

        case .ended:
            if let targetView = movingLabel.closestViewForSnapping(views: resultLabels, in: self.canvas),
               (targetView.label.text?.isEmpty ?? false) {
                targetView.set(text: movingLabel.text ?? "")
            }

            UIView.animate(withDuration: 0.01) {
                movingLabel.center = self.panStartingPoint
            }

            movingLabel.isMoving = false
            self.selectedView = nil
            self.panTrackingPoint = CGPoint.zero
            self.panStartingPoint = CGPoint.zero

            self.computationsCompleted = resultLabels.reduce(true, { partialResult, label in
                return partialResult && !(label.label.text?.isEmpty ?? false)
            })

        default:
            break;
        }
    }

    override func doneButtonClicked(_ sender: Any) {
        
        let isCorrect = self.computationViews().reduce(true) { $0 && $1.isCorrect }

        if isCorrect {
            super.doneButtonClicked(sender)
        }

        self.animate(isCorrect: isCorrect, onCorrectCompletion: { [weak self] in
            self?.configureBoard()
        })
    }
}

extension ComputationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.computations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComputationCell", for: indexPath) as! ComputationCollectionViewCell
        collectionViewCell.configure(with: self.computations[indexPath.row])
        
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: 100.0)
    }
}
