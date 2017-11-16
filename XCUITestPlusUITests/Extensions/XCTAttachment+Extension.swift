import Foundation
import XCTest

extension XCTAttachment {

    /**
     Creates a new plain `UTF-8` encoded text attachment of type `public.plain-text`.

     - Parameters:
       - name: Attachment name.
       - string: Debug String data to store in the attachement.
       - lifetime: Whether the attachment is persisted even on success. Defaults to `.deleteOnSuccess`.
     */
    convenience init(name: String, string: String, lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        self.init(string: string)

        self.name = name
        self.lifetime = lifetime
    }
}
