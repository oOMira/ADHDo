import SwiftUI
import Testing
@testable import ADHDo

/// Tests for `Binding.optional(default:)` helper.
final class BindingOptionalTests {
    @Test func testOptionalBindingReads() {
        var value: Int = 5
        let binding = Binding<Int>(
            get: { value },
            set: { value = $0 }
        )

        let optional = binding.optional

        #expect(optional.wrappedValue == 5)
        #expect(value == 5)
    }
    
    @Test func testOptionalBindingWrites() {
        var value: Int = 5
        let binding = Binding<Int>(
            get: { value },
            set: { value = $0 }
        )

        let optional = binding.optional

        optional.wrappedValue = 3
        #expect(value == 3)
        #expect(optional.wrappedValue == 3)

        optional.wrappedValue = nil
        #expect(value == 3)
        #expect(optional.wrappedValue == 3)
    }
}
