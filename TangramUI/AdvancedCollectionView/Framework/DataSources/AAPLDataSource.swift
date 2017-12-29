//
//  AAPLDataSource.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/16.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

private let AAPLGlobalSectionIndex = Int.max

let AAPLReusableIdentifierFromClass: (UIView.Type) -> String = { "\($0)" }

let AAPLCollectionElementKindPlaceholder = "AAPLCollectionElementKindPlaceholder"

class AAPLDataSource<ItemType>: NSObject, UICollectionViewDataSource {

    /// The title of this data source. This value is used to populate section headers and the segmented control tab.
    open var title: String?

    /// The number of sections in this data source.
    open func numberOfSections() -> Int {
        return 1
    }

    /// Return the number of items in a specific section. Implement this instead of the UICollectionViewDataSource method.
    open func numberOfItems(in sectionIndex: Int) -> Int {
        return 0
    }
    
    /// Find the data source for the given section. Default implementation returns self.
    open func dataSourceForSection(at sectionIndex: Int) -> AAPLDataSource {
        return self
    }
    
    /// Find the item at the specified index path. Returns nil when indexPath does not specify a valid item in the data source.
    open func item(at indexPath: IndexPath) -> ItemType? {
        return nil
    }
    
    /// Find the index paths of the specified item in the data source. An item may appear more than once in a given data source.
    open func indexPaths(for item: ItemType) -> [IndexPath]? {
        return nil
    }
    
    /// Remove an item from the data source. This method should only be called as the result of a user action, such as tapping the "Delete" button in a swipe-to-delete gesture. Automatic removal of items due to outside changes should instead be handled by the data source itself — not the controller. Data sources must implement this to support swipe-to-delete.
    open func removeItem(at indexPath: IndexPath) {}
    
    /// The primary actions that may be performed on the item at the given indexPath. These actions may change depending on the state of the item, therefore, they should not be cached except during presentation. These actions are shown on the right side of the cell. Default implementation returns an empty array.
    open func primaryActionsForItem(at indexPath: IndexPath) -> [AAPLAction] {
        return []
    }
    
    /// Secondary actions that may be performed on the item at an index path. These actions may change depending on the state of the item, therefore, they should not be cached except during presentation. These actions are shown on the left side of the cell. Default implementation returns an empty array.
    open func secondaryActionsForItem(at indexPath: IndexPath) -> [AAPLAction] {
        return []
    }
    
    /// Called when a data source becomes active in a collection view. If the data source is in the `AAPLLoadStateInitial` state, it will be sent a `-loadContent` message.
    open func didBecomeActive() {
        
    }
    
    /// Called when a data source becomes inactive in a collection view
    open func willResignActive() {
        
    }
    
    /// Should this data source allow its items to be selected? The default value is true.
    var isAllowsSelection = true
    
    // MARK: - Notifications
    
    /// Update the state of the data source in a safe manner. This ensures the collection view will be updated appropriately.
    open func performUpdate(_ update: () -> Void, complete: () -> Void) {

    }
    
    /// Update the state of the data source in a safe manner. This ensures the collection view will be updated appropriately.
    open func performUpdate(_ update: () -> Void) {
        
    }
    
    /// Notify the parent data source and the collection view that new items have been inserted at positions represented by insertedIndexPaths.
    open func notifyItemsInserted(at indexPaths: [IndexPath]) {
        
    }

    /// Notify the parent data source and collection view that the items represented by removedIndexPaths have been removed from this data source.
    open func notifyItemsRemoved(at indexPaths: [IndexPath]) {
        
    }

    /// Notify the parent data sources and collection view that the items represented by refreshedIndexPaths have been updated and need redrawing.
    open func notifyItemsRefreshed(at indexPaths: [IndexPath]) {
    
    }

    /// Alert parent data sources and the collection view that the item at indexPath was moved to newIndexPath.
    open func notifyItemMoved(from indexPath: IndexPath, toIndexPaths newIndexPath: IndexPath) {
        
    }
    
    /// Notify parent data sources and the collection view that the sections were inserted.
    open func notifySectionsInserted(_ sections: IndexSet) {
    
    }

    /// Notify parent data sources and (eventually) the collection view that the sections were removed.
    open func notifySectionsRemoved(_ sections: IndexSet) {
    
    }

    /// Notify parent data sources and the collection view that the section at oldSectionIndex was moved to newSectionIndex.
    open func notifySectionMovedFrom(_ oldSectionIndex: Int, to newSectionIndex: Int) {
    
    }

    /// Notify parent data sources and ultimately the collection view the specified sections were refreshed.
    open func notifySectionsRefreshed(_ sections: IndexSet) {

    }
    
    /// Notify parent data sources and ultimately the collection view that the data in this data source has been reloaded.
    open func notifyDidReloadData() {
        
    }
    
    /// Update the supplementary view or views associated with the header's AAPLSupplementaryItem and invalidate the layout
    open func notifyContentUpdated(forHeader header: AAPLSupplementaryItem) {

    }

    /// Update the supplementary view or views associated with the footer's AAPLSupplementaryItem and invalidate the layout
    open func notifyContentUpdated(forFooter footer: AAPLSupplementaryItem) {
        let indexPaths = self.indexPaths(for: footer, header: false)

        notifyContentUpdatedForSupplementaryItem(footer, at: indexPaths, header: false)
    }
    

    // MARK: - Metrics
    
    /// The default metrics for all sections in this data source.
    open var defaultMetrics = AAPLSectionMetrics()
    /// The metrics for the global section (headers and footers) for this data source. This is only meaningful when this is the root or top-level data source.
    open var globalMetrics = AAPLSectionMetrics()
    
    /// Retrieve the layout metrics for a specific section within this data source.
    open func metricsForSection(at sectionIndex: Int) -> AAPLSectionMetrics {
    
    }

    /// Store customised layout metrics for a section in this data source. The values specified in metrics will override values specified by the data source's defaultMetrics.
    open func setMetrics(_ metrics: AAPLSectionMetrics, forSectionAt sectionIndex: Int) {
    
    }
    
    /// Look up a data source header by its key. These headers will appear before headers from section 0. Returns nil when the header with the given key can not be found.
    open func header(for key: String) -> AAPLSupplementaryItem {
    
    }

    /// Create a new header and append it to the collection of data source headers.
    open func newHeader(for key: String) -> AAPLSupplementaryItem {
    
    }

    /// Remove a data source header specified by its key.
    open func removeHeader(for key: String) {
    
    }

    /// Replace a data source header specified by its key with a new header with the same key.
    open func replaceHeader(for key: String, with header: AAPLSupplementaryItem) {
    
    }

    /** Create a header for each section in this data source.
     
     @note The configuration block for this header will be called once for each section in the data source.
     */
    var newSectionHeader: AAPLSupplementaryItem? {
        let defaultMetrics = self.defaultMetrics as? AAPLDataSourceSectionMetrics

        let header = defaultMetrics?.newHeader as? AAPLDataSourceSupplementaryItem

        return header
    }

    /** Create a footer for each section in this data source.
     
     @note Like -newSectionHeader, the configuration block for this footer will be called once for each section in the data source.
     */
    var newSectionFooter: AAPLSupplementaryItem? {
        let defaultMetrics = self.defaultMetrics as? AAPLDataSourceSectionMetrics
        let footer = defaultMetrics?.newFooter as? AAPLDataSourceSupplementaryItem

        return footer
    }
    
    /// Create a new header for a specific section. This header will only appear in the given section.
    open func newHeaderForSection(at sectionIndex: Int) -> AAPLSupplementaryItem {
    
    }

    /// Create a new footer for a specific section. This footer will only appear in the given section.
    open func newFooterForSection(at sectionIndex: Int) -> AAPLSupplementaryItem {

    }
    
    // MARK: - Placeholders
    
    /// The placeholder to show when the data source is in the No Content state.
    open var noContentPlaceholder = AAPLDataSourcePlaceholder()
    
    /// The placeholder to show when the data source is in the Error state.
    open var errorPlaceholder = AAPLDataSourcePlaceholder()
    
    // MARK: - Subclass hooks
    
    /// Determine whether or not a cell is editable. Default implementation returns YES.
    open func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// Determine whether or not the cell is movable. Default implementation returns NO.
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// Determine whether an item may be moved from its original location to a proposed location. Default implementation returns NO.
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath) -> Bool {
        return false
    }

    /// Called by the collection view to alert the data source that an item has been moved. The data source should update its contents.
    open func collectionView(_ collectionView: UICollectionView, moveItemAt indexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath) {
        fatalError("Should be implemented by subclasses")
    }

    /// Register reusable views needed by this data source
    open func registerReusableViews(with collectionView: UICollectionView) {
        let numberOfSections = self.numberOfSections()

        let globalMetrics = snapshotMetricsForSection(at: AAPLGlobalSectionIndex)

        for headerMetrics in globalMetrics.headers {
            collectionView.register(headerMetrics.supplementaryViewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerMetrics.reuseIdentifier)
        }

        for sectionIndex in 0 ..< numberOfSections {

            let metrics = snapshotMetricsForSection(at: sectionIndex)

            for headerMetrics in metrics.headers {
                collectionView.register(headerMetrics.supplementaryViewClass,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: headerMetrics.reuseIdentifier)
            }

            for footerMetrics in metrics.footers {
                collectionView.register(footerMetrics.supplementaryViewClass,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                        withReuseIdentifier: footerMetrics.reuseIdentifier)
            }
        }

        collectionView.register(AAPLCollectionPlaceholderView.self,
                                forSupplementaryViewOfKind: AAPLCollectionElementKindPlaceholder,
                                withReuseIdentifier: AAPLReusableIdentifierFromClass(AAPLCollectionPlaceholderView.self))
    }

    private lazy var stateMachine: AAPLLoadableContentStateMachine = {
        let stateMachine = AAPLLoadableContentStateMachine()
        stateMachine.delegate = self
        return stateMachine
    }()

    // MARK: - Content loading
    
    /// Signal that the datasource should reload its content
    open func setNeedsLoadContent() {
        
    }
    
    /// Reset the content and loading state.
    open func resetContent() {
        
    }
    
    /// Use this method to wait for content to load. The block will be called once the loadingState has transitioned to the ContentLoaded, NoContent, or Error states. If the data source is already in that state, the block will be called immediately.
    open func whenLoaded(_ block: () -> Void) {
    
    }
    
    // MARK: - Private
    
    /// Create an instance of the placeholder view for this data source.
    private func dequeuePlaceholderView(for collectionView: UICollectionView, at indexPath: IndexPath) -> AAPLCollectionPlaceholderView {
    
    }
    
    /// Compute a flattened snapshot of the layout metrics associated with this and any child data sources.
    private var snapshotMetrics: [Int: AAPLDataSourceSectionMetrics] {
        let numberOfSections = self.numberOfSections()
        var metrics: [Int: AAPLDataSourceSectionMetrics] = [:]

        let globalMetrics = snapshotMetricsForSection(at: AAPLGlobalSectionIndex)
        metrics[AAPLGlobalSectionIndex] = globalMetrics

        for sectionIndex in 0 ..< numberOfSections{
            let sectionMetrics = snapshotMetricsForSection(at: sectionIndex)
            metrics[sectionIndex] = sectionMetrics
        }

        return metrics
    }

    /// Create a flattened snapshop of the layout metrics for the specified section. This resolves metrics from parent and child data sources.
    private func snapshotMetricsForSection(at sectionIndex: Int) -> AAPLDataSourceSectionMetrics {
    
    }
    
    /// Should an activity indicator be displayed while we're refreshing the content. Default is NO.
    private(set) var showsActivityIndicatorWhileRefreshingContent = false
    
    /// Will this data source show an activity indicator given its current state?
    private var shouldShowActivityIndicator: Bool {
        let loadingState = self.loadingState

        return (showsActivityIndicatorWhileRefreshingContent && loadingState == AAPLLoadStateRefreshingContent) || loadingState == AAPLLoadStateLoadingContent
    }

    private var placeholder: AAPLDataSourcePlaceholder?
    /// Will this data source show a placeholder given its current state?
    private var shouldShowPlaceholder: Bool {
        return placeholder != nil
    }

    private var loadingProgress: AAPLLoadingProgress?
    /// Load the content of this data source.
    private func loadContent() {

        loadingState = Set([AAPLLoadStateInitial, AAPLLoadStateLoadingContent]).contains(loadingState) ? AAPLLoadStateLoadingContent : AAPLLoadStateRefreshingContent
        
        notifyWillLoadContent()

        let loadingProgress = AAPLLoadingProgress { [weak self] (newState, error, update) in
            // The only time newState will be nil is if the progress was cancelled.
            guard let newState = newState else {
                return
            }
            self?.endLoadingContent(with: newState, error: error, update: {
                if let me = self {
                    update?(me)
                }
            })
        }

        // Tell previous loading instance it's no longer current and remember this loading instance
        loadingProgress.isCancelled = true
        self.loadingProgress = loadingProgress

        beginLoadingContent(with: loadingProgress)
    }

    /// The internal method which is actually called by loadContent. This allows subclasses to perform pre- and post-loading activities.
    private func beginLoadingContent(with progress: AAPLLoadingProgress) {
    
    }

    /// The internal method called when loading is complete. Subclasses may implement this method to provide synchronisation of child data sources.
    private func endLoadingContent(with state: String, error: Error?, update: () -> Void) {
    
    }
    
    /// Display an activity indicator for this data source. If sections is nil, display the activity indicator for the entire data source. The sections must be contiguous.
    private func presentActivityIndicator(for sections: IndexSet) {
    
    }
    
    /// Display a placeholder for this data source. If sections is nil, display the placeholder for the entire data source. The sections must be contiguous.
    private func presentPlaceholder(_ placeholder: AAPLDataSourcePlaceholder, for sections: IndexSet) {
    
    }

    /// Dismiss a placeholder or activity indicator
    private func dismissPlaceholder(for sections: IndexSet) {
    
    }
    
    /// Update the placeholder view for a given section.
    private func updatePlaceholderView(_ placeholderView: AAPLCollectionPlaceholderView, forSectionAt sectionIndex: Int) {
    
    }
    
    /// State machine delegate method for notifying that the state is about to change. This is used to update the loadingState property.
    func stateWillChange() {
        
    }

    /// State machine delegate method for notifying that the state has changed. This is used to update the loadingState property.
    func stateDidChange() {
        
    }
    
    /// Return the number of headers associated with the section.
    private func numberOfHeadersInSection(at sectionIndex: Int, includeChildDataSouces: Bool) -> Int {

        if AAPLGlobalSectionIndex == sectionIndex && isRootDataSource {

            return headers.count
        }

        let defaultMetrics = self.defaultMetrics as? AAPLDataSourceSectionMetrics
        var numberOfHeaders = defaultMetrics.headers.count
        
        if (!sectionIndex && !rootDataSource)
        numberOfHeaders += _headers.count;

        let sectionMetrics = _sectionMetrics[sectionIndex]
        numberOfHeaders += sectionMetrics.headers.count

        return numberOfHeaders
    }

    /// Return the number of footers associated with the section.
    private func numberOfFootersInSection(at sectionIndex: Int, includeChildDataSouces: Bool) {
        
    }
    
    /// Returns NSIndexPath instances any occurrences of the supplementary metrics in this data source. If the supplementary metrics are part of the default metrics for the data source, an NSIndexPath for each section will be returned. Returns an empty array if the supplementary metrics are not found.
    private func indexPaths(for supplementaryItem: AAPLSupplementaryItem, header: Bool) -> [IndexPath] {
    
    }
    
    /// The block will only be called if the supplementary item is found.
    private func findSupplementaryItem(for header: Bool, indexPath: IndexPath, usingBlock block: (AAPLDataSource, IndexPath, AAPLSupplementaryItem) -> Void) {
    
    }
    
    /// Get an index path for the data source represented by the global index path. This works with -dataSourceForSectionAtIndex:.
    private func localIndexPath(for globalIndexPath: IndexPath) -> IndexPath {
        return globalIndexPath
    }
    
    /// Is this data source the root data source? This depends on proper set up of the delegate property. Container data sources ALWAYS act as the delegate for their contained data sources.
    private var isRootDataSource: Bool {
        return self.delegate as? AAPLDataSource != nil
    }
    
    /// A delegate object that will receive change notifications from this data source.
    private var delegate: AAPLDataSourceDelegate?
    
    /// Notify the parent data source that this data source will load its content. Unlike other notifications, this notification will not be propagated past the parent data source.
    private func notifyWillLoadContent() {
        
    }
    
    /// Notify the parent data source that this data source has finished loading its content with the given error (nil if no error). Unlike other notifications, this notification will not propagate past the parent data source.
    private func notifyContentLoaded(with error: Error) {
    
    }
    
    private func notifySectionsInserted(_ sections: IndexSet, direction: AAPLDataSourceSectionOperationDirection) {
    
    }

    private func notifySectionsRemoved(_ sections: IndexSet, direction: AAPLDataSourceSectionOperationDirection) {
    
    }

    private func notifySectionMovedFrom(_ section: Int, to newSection: Int, direction: AAPLDataSourceSectionOperationDirection) {
        
    }
    
    private func notifyContentUpdatedForSupplementaryItem(_ metrics: AAPLSupplementaryItem, at indexPaths: [IndexPath], header: Bool) {
        
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeholder != nil ? 0 : numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Should be implemented by subclasses")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == AAPLCollectionElementKindPlaceholder {
            return dequeuePlaceholderView(for: collectionView, at: indexPath)
        }
        
        var header = false
        
        if kind == UICollectionElementKindSectionHeader {
            header = true
        } else if kind == UICollectionElementKindSectionFooter {
            header = false
        } else {
            return UICollectionReusableView()
        }
        
        var metrics: AAPLSupplementaryItem?
        var localIndexPath: IndexPath?
        var dataSource = self
        
        findSupplementaryItem(for: header, indexPath: indexPath) { (foundDataSource, foundIndexPath, foundMetrics) in
            dataSource = foundDataSource;
            localIndexPath = foundIndexPath;
            metrics = foundMetrics;
        }

        guard let _metrics = metrics else {
            return UICollectionReusableView()
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _metrics.reuseIdentifier, for: indexPath)

        _metrics.configureView?(view, dataSource as! AAPLDataSource<Any>, localIndexPath!)

        return view
    }
    
    private var resettingContent = false
}

extension AAPLDataSource: AAPLContentLoading {
    var loadingState: String {
        get {
            // Don't cause the creation of the state machine just by inspection of the loading state.
            return stateMachine.currentState ?? ""
        }
        set {
            if newValue != stateMachine.currentState {
                stateMachine.currentState = loadingState
            }
        }
    }

    var loadingError: Error? {
        get {
            
        }
        set {
            
        }
    }
    
    func loadContent(with progress: AAPLLoadingProgress) {
        
    }
}

extension AAPLDataSource: AAPLStateMachineDelegate {
    func missingTransition(from state: String, toState: String) -> String {
        if resettingContent == nil {
            return ""
        }

        if AAPLLoadStateInitial == toState {

            return toState
        }

        // All other cases fail
        return ""
    }
}
