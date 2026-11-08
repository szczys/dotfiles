import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Shows a warning icon when the running kernel no longer matches the newest
// installed kernel in /lib/modules (i.e. a kernel upgrade happened since the
// current boot). In that state new kernel modules cannot be loaded, so
// plug-in hardware (USB sticks etc.) silently stops working until a reboot.
// The module hides itself completely while the kernels match; hovering it
// explains why the reboot is needed. Clicking does nothing.
Rectangle {
    id: reboot

    // True when the running kernel is older than the newest installed one.
    property bool needed: false
    // Kernel string currently booted, kept for the hover tooltip.
    property string runningKernel: ""
    // Newest kernel installed in /lib/modules, kept for the hover tooltip.
    property string latestKernel: ""

    // True when there is nothing to show. The right Repeater reads this to
    // collapse the layout slot, and rebuildNavItems skips collapsed modules.
    readonly property bool collapsed: !reboot.needed

    // Hidden (and collapsed to zero size) while no reboot is needed.
    visible: !collapsed

    readonly property bool active: mouseArea.containsMouse

    // Tight 3px padding each side so the module sits close to its neighbours.
    implicitWidth: collapsed ? 0 : row.implicitWidth + 6
    implicitHeight: 30
    radius: 15

    // Warning tint while hovered, otherwise transparent. Red (Theme.error)
    // instead of the usual accent so the module reads as a warning.
    color: active ? Theme.error : "transparent"

    Behavior on color {
        ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
    }

    ToolTip.visible: mouseArea.containsMouse && reboot.needed
    ToolTip.delay: 300
    ToolTip.text: needed
        ? "System reboot required — running kernel " + runningKernel
          + " but " + latestKernel + " is installed. New kernel modules cannot be loaded (e.g. USB storage)."
        : ""

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Image {
            Layout.alignment: Qt.AlignVCenter
            source: "../shared/icons/reboot.svg"
            sourceSize.width: 18
            sourceSize.height: 18
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                // Red warning tint instead of the accent (icon turns
                // background-colored when hovered over the red pill).
                colorizationColor: reboot.active ? Theme.on_error : Theme.error
                Behavior on colorizationColor {
                    ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        // Clicking does nothing; the hover tooltip explains the situation.
        hoverEnabled: true
    }

    // Compare the running kernel with the newest installed one. Prints
    // "needed<TAB>running<TAB>latest" when a reboot is needed, "ok" when not.
    function refresh(): void {
        checkProc.running = false
        checkProc.running = true
    }

    Process {
        id: checkProc
        command: ["bash", "-c",
            "running=$(uname -r); " +
            "latest=$(ls /lib/modules | sort -V | tail -n 1); " +
            "if [ -n \"$latest\" ] && [ \"$running\" != \"$latest\" ]; then " +
            "  printf 'needed\\t%s\\t%s' \"$running\" \"$latest\"; " +
            "else echo ok; fi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let raw = this.text.trim()
                if (raw.startsWith("needed")) {
                    let parts = raw.split("\t")
                    reboot.runningKernel = parts.length > 1 ? parts[1] : ""
                    reboot.latestKernel = parts.length > 2 ? parts[2] : ""
                    reboot.needed = true
                } else {
                    reboot.needed = false
                }
            }
        }
    }

    // Re-check periodically so the warning appears after a kernel upgrade
    // without a restart of the bar.
    Timer {
        interval: 600 * 1000
        running: true
        repeat: true
        onTriggered: reboot.refresh()
    }
}