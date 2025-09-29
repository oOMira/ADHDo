//
//  CustomValidateableTests.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 28.11.25.
//

import Testing
import SwiftUI
@testable import ADHDo

final class CustomValidateableTests {
    @Test func testDefault() {
        var value: String = "old"
        let binding = Binding<String>(
            get: { value },
            set: { value = $0 }
        )
        
        let cell = ExpandableEditCell(expanded: .constant(false),
                                             title: "title",
                                             oldValue: .constant("old"),
                                             newValue: binding,
                                             description: { EmptyView() },
                                             saveAction: { .success })
        
        #expect(cell.isValid ==  false)
        
        binding.wrappedValue = "new"
        #expect(cell.isValid)
        
        binding.wrappedValue = ""
        #expect(cell.isValid)
    }
    
    
    @Test func testCustom_String() {
        var value: String = "old"
        let binding = Binding<String>(
            get: { value },
            set: { value = $0 }
        )

        let cell = ExpandableEditCell(expanded: .constant(false),
                                      oldText: .constant("old"),
                                      newText: binding,
                                      title: "title",
                                      saveAction: { .success })
        
        #expect(cell.isValid ==  false)
        
        binding.wrappedValue = "new"
        #expect(cell.isValid)
        
        binding.wrappedValue = ""
        #expect(cell.isValid == false)
    }
    
    @Test func testDifferentType() {
        var value: Int = 0
        let binding = Binding<Int>(
            get: { value },
            set: { value = $0 }
        )

        let cell = ExpandableEditCell(expanded: .constant(false),
                                             title: "title",
                                             oldValue: .constant(0),
                                             newValue: binding,
                                             description: { EmptyView() },
                                             saveAction: { .success })
        
        #expect(cell.isValid == false)
        binding.wrappedValue = 1
        #expect(cell.isValid)
    }

}
