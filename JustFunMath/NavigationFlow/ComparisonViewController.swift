//
//  ComputationViewController.swift
//  JustFunMath
//
//  Created by Calugar Anca Maria on 02.04.2022.
//

import UIKit

class ComparisonsViewModel {
    
    var comparisons: [Comparison] {
        self.computationsDataSource.generateComparisons(level: self.level)
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

class ComparisonViewController: ExerciseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var digitsStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.collectionViewLayout = layout
            
            self.collectionView.register(ComparisonCollectionViewCell<SingleDigitComparisonView>.self, forCellWithReuseIdentifier: "SingleDigitComparisonCell")
            self.collectionView.register(ComparisonCollectionViewCell<DoubleDigitComparisonView>.self, forCellWithReuseIdentifier: "DoubleDigitComparisonCell")
        }
    }
    
    var viewModel: ComparisonsViewModel = .init(level: .class0) {
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
        self.destinationViews = self.comparisonViews().flatMap { $0.resultLabels }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.onMovingEnded = {
            self.computationsCompleted = self.comparisonViews().map { $0.resultLabels }.reduce(true, { partialResult, resultLabels in
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

        self.loadSigns()
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
    var comparisons: [Comparison] = []

    var allDigitLabels: [RoundLabelView] = []

    func configureBoard() {
        self.computationsCompleted = false
        self.comparisons = self.viewModel.comparisons
        self.collectionView.reloadData()
    }
    
    private func loadSigns() {
        self.allDigitLabels.removeAll()
        
        let signs = ["<", "=", ">"]

        for (_, substack) in self.digitsStack.arrangedSubviews.enumerated() {
            guard let subviews = (substack as? UIStackView)?.arrangedSubviews else { return }
            for (ind2, subview) in  subviews.enumerated() {
                
            guard let roundLabelView = subview as? RoundLabelView else { return }
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

            roundLabelView.configure(with: "\(signs[ind2])", panGestureRecognizer: panGestureRecognizer)
            allDigitLabels.append(roundLabelView)
            }
        }
    }
    
    private func comparisonViews() -> [ComparisonViewProtocol] {
        var comparisonViews: [ComparisonViewProtocol] = []
        if self.viewModel.isSingleDigit {
            for cell in self.collectionView.visibleCells.compactMap({ $0 as? ComparisonCollectionViewCell<SingleDigitComparisonView> }) {
                comparisonViews.append(cell.comparisonView)
            }
        } else {
            for cell in self.collectionView.visibleCells.compactMap({ $0 as? ComparisonCollectionViewCell<DoubleDigitComparisonView> }) {
                comparisonViews.append(cell.comparisonView)
            }
        }
        
        return comparisonViews
    }

    override func doneButtonClicked(_ sender: Any) {
        
        let isCorrect = self.comparisonViews().reduce(true) { $0 && $1.isCorrect }

        if isCorrect {
            super.doneButtonClicked(sender)
        }

        self.animate(isCorrect: isCorrect, onCorrectCompletion: { [weak self] in
            self?.configureBoard()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.comparisons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel.isSingleDigit {
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleDigitComparisonCell", for: indexPath) as? ComparisonCollectionViewCell<SingleDigitComparisonView>
            collectionViewCell?.configure(with: self.comparisons[indexPath.row])
            return collectionViewCell ?? UICollectionViewCell()
        } else {
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoubleDigitComparisonCell", for: indexPath) as? ComparisonCollectionViewCell<DoubleDigitComparisonView>
            collectionViewCell?.configure(with: self.comparisons[indexPath.row])
            return collectionViewCell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }
}
