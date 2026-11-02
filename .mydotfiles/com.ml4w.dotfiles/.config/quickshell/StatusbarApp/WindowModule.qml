import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.CustomTheme

// Title of the focused window, the equivalent of waybar's hyprland/window
// module. Collapses out of the layout entirely while nothing is focused
// (empty desktop) and elides titles longer than maxWidth, optionally running
// them through rewrite rules first.
//
// Active-window tracking: Hyprland.activeToplevel is only maintained from
// activewindowv2 events, which Hyprland sends on focus *changes* — after a
// shell (re)load it is null until the next focus switch. The seed below fills
// that gap with a single hyprctl query at startup, and is dropped the moment
// the first focus event arrives (or the seeded window closes), so a stale
// title can neither linger nor resurface when activeToplevel later goes null.
Item {
    id: windowRoot

    // Width cap in pixels; longer titles are elided with an ellipsis.
    property int maxWidth: 400

    // Regular expression -> replacement map applied to the title before it
    // is shown, e.g. { "(.*) - Brave": "$1" } to strip the browser suffix.
    property var rewriteRules: ({})

    // --- Active window tracking ------------------------------------------

    property string seededAddress: ""
    property string seededTitle: ""

    readonly property string rawTitle: {
        let active = Hyprland.activeToplevel
        if (active)
            return active.title
        return windowRoot.seededAddress !== "" ? windowRoot.seededTitle : ""
    }

    // Hyprland addresses are hexadecimal and may or may not carry an 0x
    // prefix depending on where they came from (hyprctl json vs. socket
    // events), so compare them normalized.
    function addressKey(address: string): string {
        return address.startsWith("0x") ? address.slice(2) : address
    }

    Process {
        id: seedProc
        command: ["hyprctl", "activewindow", "-j"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let obj = JSON.parse(this.text.trim())
                    if (obj && obj.address && obj.title) {
                        windowRoot.seededAddress = obj.address
                        windowRoot.seededTitle = obj.title
                    }
                } catch (e) {
                    // No window focused (hyprctl returns "Invalid" or empty):
                    // nothing to seed.
                }
            }
        }
    }

    Component.onCompleted: seedProc.running = true

    Connections {
        target: Hyprland

        function onRawEvent(event): void {
            if (event.name === "activewindowv2") {
                // First focus change since (re)load: activeToplevel is
                // updated before rawEvent is emitted, so it takes over from
                // here and the seed must never resurface.
                windowRoot.seededAddress = ""
                windowRoot.seededTitle = ""
            } else if (event.name === "closewindow"
                && windowRoot.addressKey(event.data)
                    === windowRoot.addressKey(windowRoot.seededAddress)) {
                // The seeded window closed without a focus change between
                // seeding and now: drop it rather than showing a stale title.
                windowRoot.seededAddress = ""
                windowRoot.seededTitle = ""
            }
        }
    }

    // --- Presentation ----------------------------------------------------

    // The title with all rewrite rules applied. Invalid patterns fall back
    // to a literal replacement rather than taking the bar down with them.
    readonly property string title: {
        let t = windowRoot.rawTitle
        for (let pattern in windowRoot.rewriteRules) {
            try {
                t = t.replace(new RegExp(pattern, "g"), windowRoot.rewriteRules[pattern])
            } catch (e) {
                t = t.split(pattern).join(windowRoot.rewriteRules[pattern])
            }
        }
        return t
    }

    // True while there is nothing to show. Read by the Loaders in
    // StatusbarWindow so the module's layout slot collapses.
    readonly property bool collapsed: windowRoot.title === ""

    implicitWidth: Math.min(maxWidth, titleText.implicitWidth)
    implicitHeight: titleText.implicitHeight

    Text {
        id: titleText

        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(windowRoot.maxWidth, implicitWidth)
        text: windowRoot.title
        color: Theme.on_surface
        font.family: Theme.fontFamily
        font.pixelSize: 15
        elide: Text.ElideRight
    }
}
