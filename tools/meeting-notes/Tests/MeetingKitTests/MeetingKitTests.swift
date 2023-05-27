import EventKit
@testable import MeetingKit
import XCTest

final class MeetingKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let template = """
        ---
        ---
        ```dataviewjs
        dv.view(`meeting-header`)
        ```
        *

        ```dataviewjs
        dv.view("TASKS/contextual-taskview", {date: "{{date:YYYY-MM-DD HH:mm:ss}}"})
        ```

        {{notes}}

        ---
        {{attendees}}
        """
        let startDate = Date(2022, 11, 18, hour: 6, minute: 30)
        let endDate = Date(2022, 11, 18, hour: 7)
        let meeting = Meeting(startDate: startDate, endDate: endDate, title: "Test Meeting", id: "example id", attendees: [Participant(name: "Me", email: "me@me.com")], notes: "These are notes", url: nil) // URL(string: "http://google.com"))

        let expected = """
        ---
        attendees:
          - "[[Me]]"
        id: example id
        record: meeting
        title: Test Meeting
        ---
        ```dataviewjs
        dv.view(`meeting-header`)
        ```
        *

        ```dataviewjs
        dv.view("TASKS/contextual-taskview", {date: "2022-11-18 06-30"})
        ```

        ---
        These are notes

        ---

        ---
        [[Me]]
        """
        let contents = meeting.note(with: template)
        let lines = expected.split(separator: "\n")
        for (idx, line) in contents.split(separator: "\n").enumerated() {
            let otherLine = lines[idx]
            XCTAssertEqual(line, otherLine, "Line \(idx)")
            if line != otherLine {
                print("\(idx)\n\(line)\n\(otherLine)\n\n")
            }
        }
        XCTAssertEqual(expected, contents)
    }
}
