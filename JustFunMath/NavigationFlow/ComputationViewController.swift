//
//  ComputationViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class ComputationsViewModel {
    
    var computations: [Computation] {
        self.computationsDataSource.generateComputations(level: self.level)
    }
    
    private var level: ExerciseLevel
    private let computationsDataSource = ExercisesDataSource()
    
    var isSingleDigit: Bool {
        level == .class0
    }

    init(level: ExerciseLevel) {
        self.level = level
    }
}

class ComputationViewController: ExerciseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var digitsStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.collectionViewLayout = layout
            
            self.collectionView.register(ExerciseCollectionViewCell<ComputationView>.self, forCellWithReuseIdentifier: "ComputationCell")
        }
    }
    
    var viewModel: ComputationsViewModel = .init(level: .class0) {
        didSet {
            guard self.isViewLoaded && (self.view.window != nil) else { return }
            
            self.configureBoard()
            
            // making sure cells are reloaded before getting source and destination views
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.getSourceAndDestinationViews()
            })
            self.collectionView.reloadData()
            CATransaction.commit()
        }
    }
    
    func getSourceAndDestinationViews() {
        self.sourceViews = self.allDigitLabels
        self.destinationViews = self.computationViews().flatMap { $0.resultLabels }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.onMovingEnded = {
            self.computationsCompleted = self.computationViews().map { $0.resultLabels }.reduce(true, { partialResult, resultLabels in
                if resultLabels.count == 1 {
                    return partialResult && !(resultLabels[0].label.text?.isEmpty ?? false)
                } else {
                    return partialResult && !(resultLabels[1].label.text?.isEmpty ?? false)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadDigits()
        self.configureBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getSourceAndDestinationViews()
    }
    

    var computationsCompleted: Bool = false {
        didSet {
            self.doneButton.isEnabled = self.computationsCompleted
        }
    }
    var computations: [Computation] = []

    var allDigitLabels: [SingleDigitView] = []

    func configureBoard() {
        self.computationsCompleted = false
        self.computations = self.viewModel.computations
        self.collectionView.reloadData()
    }
    
    private func loadDigits() {
        self.allDigitLabels.removeAll()

        for (ind1, substack) in self.digitsStack.arrangedSubviews.enumerated() {
            guard let subviews = (substack as? UIStackView)?.arrangedSubviews else { return }
            for (ind2, subview) in  subviews.enumerated() {
                
            guard let roundLabelView = subview as? SingleDigitView else { return }
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

            roundLabelView.configure(with: "\((ind1 == 0 ? 0 : 5) + ind2)", panGestureRecognizer: panGestureRecognizer)
            allDigitLabels.append(roundLabelView)
            }
        }
    }
    
    private func computationViews() -> [ExerciseViewProtocol] {
        return self.collectionView.visibleCells
            .compactMap { $0 as? ExerciseCollectionViewCell<ComputationView> }
            .map { $0.exerciseView }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.computations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComputationCell", for: indexPath) as? ExerciseCollectionViewCell<ComputationView>
        collectionViewCell?.configure(with: self.computations[indexPath.row], isSingleDigit: self.viewModel.isSingleDigit)
        return collectionViewCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
}
