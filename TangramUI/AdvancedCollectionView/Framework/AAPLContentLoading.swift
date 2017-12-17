//
//  AAPLContentLoading.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/10.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

let AAPLLoadStateInitial = "Initial"
let AAPLLoadStateLoadingContent = "LoadingState"
let AAPLLoadStateRefreshingContent = "RefreshingState"
let AAPLLoadStateContentLoaded = "LoadedState"
let AAPLLoadStateNoContent = "NoContentState"
let AAPLLoadStateError = "ErrorState"

typealias AAPLLoadingUpdateBlock = (Any) -> Void

class AAPLLoadableContentStateMachine: AAPLStateMachine {
    override init() {
        super.init()
        validTransitions = [
            AAPLLoadStateInitial: [AAPLLoadStateLoadingContent],
            AAPLLoadStateLoadingContent: [AAPLLoadStateContentLoaded, AAPLLoadStateNoContent, AAPLLoadStateError],
            AAPLLoadStateRefreshingContent: [AAPLLoadStateContentLoaded, AAPLLoadStateNoContent, AAPLLoadStateError],
            AAPLLoadStateContentLoaded: [AAPLLoadStateRefreshingContent, AAPLLoadStateNoContent, AAPLLoadStateError],
            AAPLLoadStateNoContent: [AAPLLoadStateRefreshingContent, AAPLLoadStateContentLoaded, AAPLLoadStateError],
            AAPLLoadStateError: [AAPLLoadStateLoadingContent, AAPLLoadStateRefreshingContent, AAPLLoadStateNoContent, AAPLLoadStateContentLoaded]
        ]
        currentState = AAPLLoadStateInitial
    }
}

class AAPLLoadingProgress {
    /// Signals that this result should be ignored. Sends a nil value for the state to the completion handler.
    func ignore() {
        doneWithNewState(nil, error: nil, update: nil)
    }
    /// Signals that loading is complete with no errors. This triggers a transition to the Loaded state.
    func done() {
        doneWithNewState(AAPLLoadStateContentLoaded, error: nil, update: nil)
    }

    /// Signals that loading failed with an error. This triggers a transition to the Error state.
    func done(with error: Error?) {
        let newState = error != nil ? AAPLLoadStateError : AAPLLoadStateContentLoaded
        doneWithNewState(newState, error: error, update: nil)
    }

    /// Signals that loading is complete, transitions into the Loaded state and then runs the update block.
    func updateWithContent(_ update: @escaping AAPLLoadingUpdateBlock) {
        doneWithNewState(AAPLLoadStateContentLoaded, error: nil, update: update)
    }

    /// Signals that loading completed with no content, transitions to the No Content state and then runs the update block.
    func updateWithNoContent(_ update: @escaping AAPLLoadingUpdateBlock) {
        doneWithNewState(AAPLLoadStateNoContent, error: nil, update: update)
    }
    
    /// Has this loading operation been cancelled? It's important to check whether the loading progress has been cancelled before calling one of the completion methods (-ignore, -done, -doneWithError:, updateWithContent:, or -updateWithNoContent:). When loading has been cancelled, updating via a completion method will throw an assertion in DEBUG mode.
    private(set) var isCancelled = false {
        didSet {
            ignore()
        }
    }
    
    private var block: ((String?, Error?, AAPLLoadingUpdateBlock?) -> Void)?

    /// create a new loading helper
    init(handler: @escaping (String?, Error?, AAPLLoadingUpdateBlock?) -> Void) {
        self.block = handler
    }
    
    private func doneWithNewState(_ newState: String?, error: Error?, update: AAPLLoadingUpdateBlock?) {

        let block = self.block
        
        DispatchQueue.main.async {
            block?(newState, error, update)
        }
        
        self.block = nil
    }
}

/// A protocol that defines content loading behavior
protocol AAPLContentLoading {
    /// The current state of the content loading operation
    var loadingState: String { set get }
    /// Any error that occurred during content loading. Valid only when loadingState == AAPLLoadStateError.
    var loadingError: Error? { set get }
    
    /// Public method used to begin loading the content.
    func loadContent(with progress: AAPLLoadingProgress)
    /// Public method used to reset the content of the receiver.
    func resetContent()
}
