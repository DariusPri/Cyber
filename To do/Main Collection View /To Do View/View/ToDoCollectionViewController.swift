//
//  ToDoCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 28/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


// MARK: - ToDoViewControllerInput

/// _ToDoViewControllerInput_ is a protocol for view controller input behaviours
protocol ToDoViewControllerInput: ToDoPresenterOutput {
    func updateAfterCheckboxAction()
}


// MARK: - ToDoViewControllerOutput

/// _ToDoViewControllerInput_ is a protocol for view controller output behaviours
protocol ToDoViewControllerOutput {
    
    var loadingTasks : Bool { get set }
    var taskDatas: [TaskData]? { get }
    var filteredPirorityDataArray : [PriorityFilterData] {get set}
    var filteredStatusDataArray : [StatusFilterData] {get set}
    var filteredDeviceDataArray : [DeviceFilterData] {get set}
    
    /// Tells the output (interactor) to fetch all To do tasks
    func fetchToDoTaskDatas()
    
    /// Tells the output (interactor) to filter Tasks
    ///
    /// - parameter pirorityDataArray: Priority data array
    /// - parameter statusDataArray: Status data array
    /// - parameter deviceDataArray: Device data array
    func filterTasks(with pirorityDataArray : [PriorityFilterData], statusDataArray : [StatusFilterData], deviceDataArray : [DeviceFilterData])
    
    /// Tells the output (interactor) to tick completed task
    ///
    /// - parameter index: Task's index
    func tickCompletedTask(at index: Int)
    
    /// Tells the output (interactor) to set a timer for a task
    ///
    /// - parameter index: Task's index
    func setTimerDuration(for days : Int, at index: Int)
    
    /// Tells the output (interactor) to cancel a timer for task
    ///
    /// - parameter index: Task's index
    func cancelTimerDuration(at index: Int)
    
    /// Tells the output (interactor) to show How to if needed (if plan lets)
    ///
    /// - parameter index: Task's index
    func showToDoIfNeeded(for index : Int)
}


// MARK: - ToDoCollectionViewController

/// _ToDoCollectionViewController_ is a view controller responsible for displaying ToDo details like a list of tasks
class ToDoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var output: ToDoViewControllerOutput!
    var router: ToDoRouterProtocol!
    
    fileprivate var toDoDataViewModels: [ToDoDataViewModel]?
    
    func noTasksBackgroundViewIfNeeded() {
        if (self.toDoDataViewModels?.count ?? 0) >= 0 || self.dataIsFiltered == true { self.collectionView?.backgroundView = nil; return }
        self.collectionView?.reloadData()
        let bgView = NoTasksBackgroundView(frame: self.view.bounds)
        self.collectionView?.backgroundView = bgView
    }
    
    func setLoadingBackgroundViewIfNeeded() {
        if self.collectionView?.backgroundView == nil && toDoDataViewModels == nil {
            self.collectionView?.backgroundView = LoadingBakcgroundView(frame: self.view.bounds)
        }
    }
    
    var dataIsFiltered : Bool = false
    var correctCollectionViewWidth : CGFloat = 300
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of _ToDoCollectionViewController_ with a configurator
    ///
    /// - parameter configurator: The configurator
    ///
    /// - returns: The instance of _ToDoCollectionViewController_
    init(configurator: ToDoConfigurator = ToDoConfigurator.sharedInstance) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(configurator: configurator)
    }
    
    /// Initializes an instance of _ToDoCollectionViewController_ from storyboard
    ///
    /// - parameter coder: The coder
    ///
    /// - returns: The instance of _ToDoCollectionViewController_
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(configurator: ToDoConfigurator.sharedInstance)
    }
    
    // MARK: - Configurator
    
    private func configure(configurator: ToDoConfigurator = ToDoConfigurator.sharedInstance) {
        configurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = .clear
        self.collectionView!.register(ToDoCollectionViewCell.self, forCellWithReuseIdentifier: "ToDoCollectionViewCell")
        self.collectionView?.register(ToDoCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoCollectionViewHeader")
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = view.getCorrectSize(15, 15, 20)
            layout.sectionHeadersPinToVisibleBounds = true
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 720)) / 2
        collectionView?.contentInset = .init(top: 0, left: horizontalInset, bottom: 50, right: horizontalInset)
        correctCollectionViewWidth = view.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
    }
    
    // MARK: - Event handling

    func fetchToDoTasks() {
        noTasksBackgroundViewIfNeeded()
        setLoadingBackgroundViewIfNeeded()
        output.fetchToDoTaskDatas()
    }
    
    @objc func checkBoxTickAction(sender : UIButton) {
        output.tickCompletedTask(at: sender.tag)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return UIEdgeInsets.init(top: 15, left: 0, bottom: 15, right: 0) }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoCollectionViewHeader", for: indexPath) as! ToDoCollectionViewHeader
        header.filterTasksButton.addTarget(self, action: #selector(filterTasksAction), for: .touchUpInside)
        header.filteringIs(enabled: dataIsFiltered)
        header.removeFilteringButton.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: correctCollectionViewWidth-30, height: collectionView.getCorrectSize(60, 60, 80))
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return (((self.output.taskDatas?.count ?? 0) > 0) || (dataIsFiltered == true)) ? 1 : 0 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return toDoDataViewModels?.count ?? 0 }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = toDoDataViewModels?[indexPath.item] else { return UICollectionViewCell(frame: .zero) }
        
        func addMoreButtonAction(cell : ToDoBaseCollectionViewCell) {
            cell.priorityImageView.setupWith(priority: data.priority)
            cell.moreButtonCompletionAction = { cell in
                if let index = collectionView.indexPath(for: cell)?.item {
                    self.setReminder(at: index)
                }
            }
            cell.checkBoxButton.tag = indexPath.item
            cell.checkBoxButton.addTarget(self, action: #selector(checkBoxTickAction(sender:)), for: .touchUpInside)
            cell.containerWidthLayout?.constant = correctCollectionViewWidth - 30
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoCollectionViewCell", for: indexPath) as! ToDoCollectionViewCell
        cell.howToDoItCompletionAction = { cell in if let index = collectionView.indexPath(for: cell)?.item { self.showTutorial(at: index) } }
        cell.data = data
        addMoreButtonAction(cell: cell as ToDoBaseCollectionViewCell)
        return cell
    }

}


extension ToDoCollectionViewController {
    
    @objc func removeFilter() {
        self.dataIsFiltered = false
        self.output.filteredPirorityDataArray = []
        self.output.filteredStatusDataArray = []
        self.output.filteredDeviceDataArray = []
        output.fetchToDoTaskDatas()
    }
    
    @objc func filterTasksAction() {
        let popupVC = TasksFilterPopupViewController(title: Localization.shared.to_filter_tasks, rightButton: nil)
        popupVC.filterCollectionViewController.filteredDeviceDataArray = self.output.filteredDeviceDataArray
        popupVC.filterCollectionViewController.filteredStatusDataArray = self.output.filteredStatusDataArray
        popupVC.filterCollectionViewController.filteredPriorityDataArray = self.output.filteredPirorityDataArray
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.transitioningDelegate = popupVC
        popupVC.popupCloseCompletion = {
            let priorities = popupVC.filterCollectionViewController.priorityDataArray.filter({ $0.isSelected == true })
            let status = popupVC.filterCollectionViewController.statusDataArray.filter({ $0.isSelected == true })
            let device = popupVC.filterCollectionViewController.deviceDataArray.filter({ $0.isSelected == true })
            self.dataIsFiltered = (priorities.count > 0 || status.count > 0 || device.count > 0)
            self.output.filterTasks(with: priorities, statusDataArray: status, deviceDataArray: device)
        }
        present(popupVC, animated: true, completion: nil)
    }
    
    @objc func setReminder(at index : Int) {
        guard let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? ToDoBaseCollectionViewCell else { return }
        let reminderPopup = UIAlertController(title: nil, message: Localization.shared.to_set_a_reminder, preferredStyle: UIAlertController.Style.actionSheet)
        reminderPopup.view.tintColor = UIColor.mainBlue
        reminderPopup.popoverPresentationController?.sourceView = cell.moreButton
        reminderPopup.popoverPresentationController?.sourceRect = cell.moreButton.bounds
        reminderPopup.addAction(UIAlertAction(title: Localization.shared.to_reminder_set_for_1_day, style: .default, handler: { (_) in self.output.setTimerDuration(for: 1, at: index) }))
        reminderPopup.addAction(UIAlertAction(title: Localization.shared.to_reminder_set_for_days_days.doubleBracketReplace(with: "5"), style: .default, handler: { (_) in self.output.setTimerDuration(for: 5, at: index) }))
        reminderPopup.addAction(UIAlertAction(title: Localization.shared.to_reminder_set_for_weeks_weeks.doubleBracketReplace(with: "2"), style: .default, handler: { (_) in self.output.setTimerDuration(for: 14, at: index) }))
        reminderPopup.addAction(UIAlertAction(title: Localization.shared.cancel, style: .cancel, handler: { (_) in }))
        present(reminderPopup, animated: true, completion: nil)
    }
    
    @objc func cancelReminder(at index : Int) {
        self.output.cancelTimerDuration(at: index)
    }
    
    @objc func showTutorial(at index : Int) {
        self.output.showToDoIfNeeded(for: index)
    }
    
    func updateTabBarIcons() {
        guard let todoVC = self.parent as? ToDoViewController else { return }
        
        if self.toDoDataViewModels?.contains(where: { $0.status == .overdue }) == true {
            todoVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "todo_selected_overdue_ic")
            todoVC.tabBarItem.image = #imageLiteral(resourceName: "todo_unselected_overdue_ic")
        } else {
            todoVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "todo_selected_ic")
            todoVC.tabBarItem.image = #imageLiteral(resourceName: "todo_unselected_ic")
        }
    }
}


extension ToDoCollectionViewController : ToDoViewControllerInput {
    func updateAfterCheckboxAction() {
        self.output.fetchToDoTaskDatas()
    }
}

extension ToDoCollectionViewController : ToDoPresenterOutput, ErrorPresenter {

    func displayToDo(viewModels: [ToDoDataViewModel]) {
        self.toDoDataViewModels = viewModels
        (self.parent as? ToDoViewController)?.subtitleLabel.text = Localization.shared.x_tasks.doubleBracketReplace(with: String(viewModels.count))
        self.collectionView.reloadDataWithoutScroll()
        noTasksBackgroundViewIfNeeded()
        updateTabBarIcons()
        self.output.loadingTasks = false
    }
    
    func displaySuccessfulReloadTask(at index: Int, withModels viewModels: [ToDoDataViewModel]) {
        self.toDoDataViewModels = viewModels
        self.collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
        updateTabBarIcons()
        self.output.loadingTasks = false
    }
    
    func displayError(viewModel: ErrorViewModel) {
        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: viewModel.errorText!.joined()) {}
    }
    
    func displayToDoPopup(at index: Int) {
        self.router.navigateToToDo(index: index)
    }
    
    func displayDemoPopup() {
        self.router.navigateToDemoPopup()
    }
    
    func displayLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
    }
    
    func displaySuccessfulDeletedTask(at index: Int) {
        self.output.fetchToDoTaskDatas()
    }
}



extension UICollectionView {
    func reloadDataWithoutScroll() {
        let contentOffset = self.contentOffset
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.setContentOffset(contentOffset, animated: false)
        })
        self.reloadData()
        CATransaction.commit()
    }
}
