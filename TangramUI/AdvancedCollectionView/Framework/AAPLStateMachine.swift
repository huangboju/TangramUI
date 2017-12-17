//
//  AAPLStateMachine.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/10.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

protocol AAPLStateMachineDelegate: class {
    // Completely generic state change hook
    func stateWillChange()
    
    func stateDidChange()
    
    /// Return the new state or nil for no change for an missing transition from a state to another state. If implemented, overrides the base implementation completely.
    func missingTransition(from state: String, toState: String) -> String
}

private let AAPLStateNil = "Nil"

class AAPLStateMachine {
    var validTransitions: [String: [String]] = [:]
    
    var currentState: String? {
        set {
            _currentState = newValue
        }
        get {
            var currentState: String?
            // for atomic-safety, _currentState must not be released between the load of _currentState and the retain invocation
            os_unfair_lock_lock(&lock)
            currentState = self.currentState
            os_unfair_lock_unlock(&lock)
            return currentState
        }
    }
    
    private var _currentState: String?
    
    weak var delegate: AAPLStateMachineDelegate?
    
    /// use NSLog to output state transitions useful for debugging, but can be noisy
    var shouldLogStateTransitions = false
    
    private var lock = os_unfair_lock()
    
    var target: AnyObject {
        return delegate ?? self
    }
    
    /// set current state and return YES if the state changed successfully to the supplied state, NO otherwise. Note that this does _not_ bypass `-missingTransitionFromState:toState:`, so, if you invoke this, you must also supply a `-missingTransitionFromState:toState:` implementation that avoids raising exceptions.
    func applyState(_ state: String) -> Bool {
        return attemptToSetCurrentState(state)
    }

    func attemptToSetCurrentState(_ toState: String) -> Bool {
        let fromState = self.currentState
        
        if shouldLogStateTransitions {
            print(" ••• request state change from \(fromState ?? "") to \(toState)")
        }
        
        let appliedToState = validateTransition(fromState, toState: toState)
        if appliedToState == nil {
            return false
        }
        
        // ...send will-change message for downstream KVO support...
        
        let target = self.target
        
        let genericWillChangeAction = Selector(("stateWillChange"))
        
        if target.responds(to: genericWillChangeAction) {
            _ = target.perform(genericWillChangeAction)
        }
        
        os_unfair_lock_lock(&lock)
        self.currentState = appliedToState
        os_unfair_lock_unlock(&lock)
        
        // ... send messages
        performTransitionFromState(fromState, toState: appliedToState!)

        return toState == appliedToState
    }
    
    /// For subclasses. Base implementation raises IllegalStateTransition exception. Need not invoke super unless desired. Should return the desired state if it doesn't raise, or nil for no change.
    func missingTransition(from state: String, toState: String) -> String? {
        return nil
    }
    
    private func validateTransition(_ fromState: String?, toState: String) -> String? {
        // Transitioning to the same state (fromState == toState) is always allowed. If it's explicitly included in its own validTransitions, the standard method calls below will be invoked. This allows us to avoid creating states that exist only to reexecute transition code for the current state.

        // Raise exception if this is an illegal transition (toState must be a validTransition on fromState)
//        if let fromState = fromState {
//            let validTransitions = self.validTransitions[fromState]
//            var transitionSpecified = true
//
//            // Multiple valid transitions
//
//            if let validTransitions = validTransitions, !validTransitions.contains(toState) {
//                transitionSpecified = false
//            }
//        }

        return toState
    }
    
    private func triggerMissingTransitionFromState(_ fromState: String, toState: String) -> String {
        if let delegate = self.delegate {
            return delegate.missingTransition(from: fromState, toState: toState)
        }
        return triggerMissingTransitionFromState(fromState, toState: toState)
    }
    
    private func performTransitionFromState(_ fromState: String?, toState: String) {
        // Subclasses may implement several different selectors to handle state transitions:
        //
        //  did enter state (didEnterPaused)
        //  did exit state (didExitPaused)
        //  transition between states (stateDidChangeFromPausedToPlaying)
        //  generic transition handler (stateDidChange), for common tasks
        //
        // Any and all of these that are implemented will be invoked.
        
        if shouldLogStateTransitions {
            print("  ••• \(self) state change from \(fromState ?? "") to \(toState)")
        }
        
        let target = self.target
        
        if let fromState = fromState {
            let exitStateAction = Selector("didExit\(fromState)")
            if target.responds(to: exitStateAction) {
                _ = target.perform(exitStateAction)
            }
        }

        let enterStateAction = Selector("didEnter\(toState)")
        if target.responds(to: enterStateAction) {
            _ = target.perform(enterStateAction)
        }
        
        let fromStateNotNil = fromState ?? AAPLStateNil

        let transitionAction = Selector("stateDidChangeFrom\(fromStateNotNil)To\(toState)")
        if target.responds(to: transitionAction) {
            _ = target.perform(transitionAction)
        }

        let genericDidChangeAction = Selector(("stateDidChange"))
        if target.responds(to: genericDidChangeAction) {
            _ = target.perform(genericDidChangeAction)
        }
    }
}
