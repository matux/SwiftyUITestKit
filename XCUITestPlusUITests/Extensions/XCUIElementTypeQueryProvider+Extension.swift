import Foundation
import XCTest

/**
 Extends the `XCUIElementQuery` provider to also provide ready-made `firstMatch` queries. Meaning the queries
 returned will already have `firstMatch` applied.

 Singular nouns counterparts to the ones already available are used with the intention of communicating
 the expectation that only one element (the first match) will be returned once the query is resolved.

     app.button["Foo"].tap()

 These produce the same results:

     app.button["Foo"].tap()
     app.buttons["Foo"].firstMatch.tap()
     app.descendants(matching: .button)["Foo"].firstMatch.tap()
     app.descendants(matching: .button).matching(identifier: "Foo").firstMatch.tap()

 - Note:
 `XCUIElementTypeQueryProvider` is adopted by `XCUIElement` and `XCUIElementQuery`.

 - Remark:
 See `DescendantQuerying` `protocol` down below for implementation details.
 */
extension XCUIElementTypeQueryProvider where Self: DescendantQuerying {

    typealias Q = ElementFirstMatchQuery

    var any: Q { return self « .any }
    var other: Q { return self « .other }
    var application: Q { return self « .application }
    var group: Q { return self « .group }
    var window: Q { return self « .window }
    var touchBar: Q { return self « .touchBar }
    var sheet: Q { return self « .sheet }
    var drawer: Q { return self « .drawer }
    var alert: Q { return self « .alert }
    var dialog: Q { return self « .dialog }
    var button: Q { return self « .button }
    var radioButton: Q { return self « .radioButton }
    var radioGroup: Q { return self « .radioGroup }
    var checkBox: Q { return self « .checkBox }
    var disclosureTriangle: Q { return self « .disclosureTriangle }
    var popUpButton: Q { return self « .popUpButton }
    var comboBox: Q { return self « .comboBox }
    var menuButton: Q { return self « .menuButton }
    var toolbarButton: Q { return self « .toolbarButton }
    var popover: Q { return self « .popover }
    var keyboard: Q { return self « .keyboard }
    var key: Q { return self « .key }
    var navigationBar: Q { return self « .navigationBar }
    var tabBar: Q { return self « .tabBar }
    var tabGroup: Q { return self « .tabGroup }
    var toolbar: Q { return self « .toolbar }
    var statusBar: Q { return self « .statusBar }
    var table: Q { return self « .table }
    var tableRow: Q { return self « .tableRow }
    var tableColumn: Q { return self « .tableColumn }
    var outline: Q { return self « .outline }
    var outlineRow: Q { return self « .outlineRow }
    var browser: Q { return self « .browser }
    var collectionView: Q { return self « .collectionView }
    var slider: Q { return self « .slider }
    var pageIndicator: Q { return self « .pageIndicator }
    var progressIndicator: Q { return self « .progressIndicator }
    var activityIndicator: Q { return self « .activityIndicator }
    var segmentedControl: Q { return self « .segmentedControl }
    var picker: Q { return self « .picker }
    var pickerWheel: Q { return self « .pickerWheel }
    var `switch`: Q { return self « .`switch` }
    var toggle: Q { return self « .toggle }
    var link: Q { return self « .link }
    var image: Q { return self « .image }
    var icon: Q { return self « .icon }
    var searchField: Q { return self « .searchField }
    var scrollView: Q { return self « .scrollView }
    var scrollBar: Q { return self « .scrollBar }
    var staticText: Q { return self « .staticText }
    var textField: Q { return self « .textField }
    var secureTextField: Q { return self « .secureTextField }
    var datePicker: Q { return self « .datePicker }
    var textView: Q { return self « .textView }
    var menu: Q { return self « .menu }
    var menuItem: Q { return self « .menuItem }
    var menuBar: Q { return self « .menuBar }
    var menuBarItem: Q { return self « .menuBarItem }
    var map: Q { return self « .map }
    var webView: Q { return self « .webView }
    var stepper: Q { return self « .stepper }
    var incrementArrow: Q { return self « .incrementArrow }
    var decrementArrow: Q { return self « .decrementArrow }
    var tab: Q { return self « .tab }
    var timeline: Q { return self « .timeline }
    var ratingIndicator: Q { return self « .ratingIndicator }
    var valueIndicator: Q { return self « .valueIndicator }
    var splitGroup: Q { return self « .splitGroup }
    var splitter: Q { return self « .splitter }
    var relevanceIndicator: Q { return self « .relevanceIndicator }
    var colorWell: Q { return self « .colorWell }
    var helpTag: Q { return self « .helpTag }
    var matte: Q { return self « .matte }
    var dockItem: Q { return self « .dockItem }
    var ruler: Q { return self « .ruler }
    var rulerMarker: Q { return self « .rulerMarker }
    var grid: Q { return self « .grid }
    var levelIndicator: Q { return self « .levelIndicator }
    var cell: Q { return self « .cell }
    var layoutArea: Q { return self « .layoutArea }
    var layoutItem: Q { return self « .layoutItem }
    var handle: Q { return self « .handle }
    var statusItem: Q { return self « .statusItem }

    // MARK: - Private

    // Some black magic to improve readability. We do *not* want to make this part of the standard
    // `XCUIElementTypeQueryProvider` interface.
    fileprivate static func « (provider: Self, type: XCUIElement.`Type`) -> ElementFirstMatchQuery {
        let descendants = provider.descendants(matching: type)
        return ElementFirstMatchQuery(underlyingQuery: descendants)
    }
}

// MARK: - Hackery

/**
 Wraps around `XCUIElementQuery` to provide a `firstMatch` subscript. This is what enables us to maintain a
 similar interface to `XCUIElementQuery`.

 An ideal implementation would involve subclassing `XCUIElementQuery`, but its `init` is `private`.
 */
struct ElementFirstMatchQuery {

    /// Underlying query we're wrapping
    let underlyingQuery: XCUIElementQuery

    /**
     Keyed subscripting is implemented as a shortcut for *first* matching an identifier only.
     For example, app.buttons["Foo"].firstMatch -> XCUIElement.

     Replaces the underlying query's subscript implementation by applying a `firstMatch` query resolution.

     Sole functionality provided by this struct.

     - Parameter key: String identifying the element.
     */
    subscript(key: String) -> XCUIElement {
        return self.underlyingQuery[key].firstMatch
    }
}

/**
 Given this function is declared on `XCUIElement` and `XCUIElementQuery` separately instead of being all
 swifty and declare it on a `protocol`, we need to infuse some protocol goodness flexibility.
 */
protocol DescendantQuerying {

    /// Returns a query for all descendants of the element matching the specified type.
    func descendants(matching type: XCUIElement.`Type`) -> XCUIElementQuery
}

extension XCUIElement: DescendantQuerying { }
extension XCUIElementQuery: DescendantQuerying { }
