import Testing
import SwiftUI
@testable import ADHDo

final class BindingInvertTests {
    @Test func testInvertedBinding_getsNegatedValue() {
        var value = true
        let binding = Binding<Bool>(
            get: { value },
            set: { value = $0 }
        )

        let inverted = binding.inverted

        #expect(binding.wrappedValue == true)
        #expect(inverted.wrappedValue == false)
    }

    @Test func testInvertedBinding_setsNegatedValueToUnderlying() {
        var value = true
        let binding = Binding<Bool>(
            get: { value },
            set: { value = $0 }
        )

        let inverted = binding.inverted

        inverted.wrappedValue = true
        #expect(value == false)

        inverted.wrappedValue = false
        #expect(value == true)
    }

    @Test func testDoubleInversion_behavesLikeOriginal() {
        var value = true
        let binding = Binding<Bool>(
            get: { value },
            set: { value = $0 }
        )

        let inverted = binding.inverted
        let doubleInverted = binding.inverted.inverted

        #expect(inverted.wrappedValue == false)
        #expect(doubleInverted.wrappedValue == true)

        doubleInverted.wrappedValue = false
        #expect(value == false)
        #expect(inverted.wrappedValue == true)
    }
}
