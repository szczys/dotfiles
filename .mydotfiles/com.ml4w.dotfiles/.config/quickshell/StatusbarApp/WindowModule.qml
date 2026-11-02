import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.CustomTheme

// Title of the window on *this bar's monitor*, the per-monitor equivalent of
// waybar's hyprland/window module. One bar runs per screen (see shell.qml), and
// each shows the window that has focus on its own monitor's active workspace:
//
//  - On the focused monitor that is Hyprland.activeToplevel (live).
//  - On every other monitor it is the workspace's last-focused window, as
//    reported by Hyprland in `hyprctl workspaces -j` ("lastwindow"), resolved
//    to its live toplevel so title changes still show up.
//
// Collapses out of the layout entirely while the workspace is empty and elides
// titles longer than maxWidth, optionally running them through rewrite rules
// first.
//
// Hyprland.activeToplevel is only maintained from activewindowv2 events, so it
// is null after a shell (re)load until the next focus switch. The workspace
// "lastwindow" path covers that gap too: after the initial refresh below, the
// focused monitor's last window is the focused window.
Item {
    id: windowRoot

    // The screen this bar is on. Set by StatusbarWindow.
    property ShellScreen screen: null

    // Width cap in pixels; longer titles are elided with an ellipsis.
    property int maxWidth: 400

    // Regular expression -> replacement map applied to the title before it
    // is shown, e.g. { "(.*) - Brave": "$1" } to strip the browser suffix.
    property var rewriteRules: ({})

    // --- Per-monitor window tracking -------------------------------------

    readonly property HyprlandMonitor monitor:
        windowRoot.screen ? Hyprland.monitorFor(windowRoot.screen) : null
    readonly property HyprlandWorkspace workspace:
        windowRoot.monitor ? windowRoot.monitor.activeWorkspace : null

    // Hyprland addresses are hexadecimal and may or may not carry an 0x
    // prefix depending on where they came from (hyprctl json vs. socket
    // events), so compare them normalized.
    function addressKey(address: string): string {
        return address.startsWith("0x") ? address.slice(2) : address
    }

    readonly property string rawTitle: {
        let ws = windowRoot.workspace
        if (!ws)
            return ""

        // Focused window, if it lives on this monitor's workspace.
        let active = Hyprland.activeToplevel
        if (active && active.workspace === ws)
            return active.title

        // Otherwise the workspace's last-focused window.
        let ipc = ws.lastIpcObject
        let last = (ipc && ipc.lastwindow) ? windowRoot.addressKey(ipc.lastwindow) : ""
        if (last === "" || last === "0")
            return ""
        let tls = ws.toplevels.values
        for (let i = 0; i < tls.length; i++) {
            if (windowRoot.addressKey(tls[i].address) === last)
                return tls[i].title
        }
        // Not resolved to a live toplevel yet (e.g. right after startup):
        // fall back to the title Hyprland reported with the workspace.
        return ipc.lastwindowtitle || ""
    }

    // lastIpcObject is only refreshed on request, so re-query workspaces
    // whenever the per-workspace last window can have changed. Coalesced so a
    // burst of events costs a single hyprctl round trip.
    Timer {
        id: refreshTimer
        interval: 50
        onTriggered: {
            Hyprland.refreshWorkspaces()
            Hyprland.refreshToplevels()
        }
    }

    Component.onCompleted: refreshTimer.start()

    Connections {
        target: Hyprland

        function onRawEvent(event): void {
            switch (event.name) {
            case "activewindowv2":
            case "openwindow":
            case "closewindow":
            case "movewindowv2":
            case "workspacev2":
            case "focusedmonv2":
            case "moveworkspacev2":
                refreshTimer.restart()
                break
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
