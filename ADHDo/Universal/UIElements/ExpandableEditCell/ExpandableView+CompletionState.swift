//
//  ExpandableEditCell+CompletionState.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 13.11.25.
//

extension ExpandableView {
    /// Describes the result of an async completion operation performed by
    /// `ExpandableView` editors (save/clear actions).
    ///
    /// Use this enum to convey whether an operation succeeded or failed and to
    /// provide an optional error message that can be displayed to the user.
    enum CompletionState {
        /// The operation failed. The associated `String` value contains an
        /// optional user-facing error message explaining the failure.
        case failure(String)

        /// The operation completed successfully.
        case success
    }
}
