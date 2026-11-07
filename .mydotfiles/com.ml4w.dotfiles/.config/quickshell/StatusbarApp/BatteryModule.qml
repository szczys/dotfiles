import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Battery indicator modelled on the ML4W Waybar battery module. Shown only on
// machines that have a laptop battery. The data comes from UPower's display
// device, and the icon follows the battery's real state (not just AC presence):
//
//   charging              -> battery-charging icon + percent
//   plugged, not charging -> plug icon + percent (e.g. held at a charge limit,
//                            or fully charged)
//   on battery            -> charge-level icon (empty/low/medium/full) + percent
//
// Below criticalLevel while not charging, the module blinks between the error
// color and its normal look (Waybar's #battery.critical:not(.charging)).
// Clicking (or keyboard Return) toggles between percent and time remaining
// (Waybar's format-alt).
Rectangle {
    id: battery

    // The aggregate battery UPower exposes for the whole machine.
    readonly property var device: UPower.displayDevice
    // True when this machine has a real, present laptop battery. This is the
    // sole condition for showing the module (a desktop reports none).
    readonly property bool hasBattery: device !== null
        && device.isLaptopBattery && device.isPresent
    // Rounded charge percentage (0–100). UPower's percentage is a 0.0–1.0
    // fraction, so scale it up before rounding.
    readonly property int percent: device ? Math.round(device.percentage * 100) : 0
    readonly property int batteryState: device ? device.state : UPowerDeviceState.Unknown

    // Waybar's "critical" state threshold (percent).
    readonly property int criticalLevel: 15

    // Power is actually flowing into the battery.
    readonly property bool charging: batteryState === UPowerDeviceState.Charging
    // On AC but not charging: held at a charge limit, or full.
    readonly property bool plugged: !charging && (!UPower.onBattery
        || batteryState === UPowerDeviceState.PendingCharge
        || batteryState === UPowerDeviceState.FullyCharged)
    readonly property bool critical: hasBattery && !charging && !plugged
        && percent <= criticalLevel

    // Preview switch: while true the module is shown with a demo charge so the
    // layout can be reviewed on a machine that has no battery (a desktop).
    // Set to false for the final implementation.
    property bool preview: false

    // Shown whenever a laptop battery exists. In preview mode it is always shown.
    readonly property bool collapsed: !preview && !hasBattery
    readonly property int shownPercent: preview && !hasBattery ? 72 : percent

    // Click toggles the label between percent and time remaining.
    property bool showTime: false
    // Set by the keyboard navigation in StatusbarWindow.
    property bool focused: false

    function activate(): void {
        battery.showTime = !battery.showTime
    }

    // Time remaining as "H h M min" (Waybar's default {time} format): time to
    // full while charging, time to empty on battery. UPower reports 0 when it
    // has no estimate (e.g. plugged in but not charging).
    readonly property string timeText: {
        if (!device)
            return "--"
        const secs = charging ? device.timeToFull : device.timeToEmpty
        if (!secs || secs <= 0)
            return "--"
        const h = Math.floor(secs / 3600)
        const m = Math.floor((secs % 3600) / 60)
        return h > 0 ? h + " h " + m + " min" : m + " min"
    }

    readonly property string iconSource: {
        if (charging)
            return "../shared/icons/battery-charging.svg"
        if (plugged)
            return "../shared/icons/plug.svg"
        if (shownPercent <= criticalLevel)
            return "../shared/icons/battery-empty.svg"
        if (shownPercent <= 40)
            return "../shared/icons/battery-low.svg"
        if (shownPercent <= 70)
            return "../shared/icons/battery-medium.svg"
        return "../shared/icons/battery-full.svg"
    }

    visible: !collapsed

    // Hover / keyboard selection highlight, same as the other bar modules.
    readonly property bool active: mouseArea.containsMouse || battery.focused

    // Critical blink: alternates every 500 ms while critical (and not hovered).
    property bool blinkOn: false
    Timer {
        interval: 500
        repeat: true
        running: battery.critical && battery.visible
        onTriggered: battery.blinkOn = !battery.blinkOn
        onRunningChanged: if (!running) battery.blinkOn = false
    }
    readonly property bool alert: critical && blinkOn && !active

    readonly property color fgColor: active ? Theme.background
        : alert ? Theme.on_error : Theme.primary

    implicitWidth: collapsed ? 0 : row.implicitWidth + 16
    implicitHeight: 30
    radius: 15
    color: active ? Theme.primary : alert ? Theme.error : "transparent"
    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.OutQuint }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Image {
            Layout.alignment: Qt.AlignVCenter
            source: battery.iconSource
            sourceSize.width: 18
            sourceSize.height: 18
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: battery.fgColor
                Behavior on colorizationColor {
                    ColorAnimation { duration: 300; easing.type: Easing.OutQuint }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: battery.showTime ? battery.timeText : battery.shownPercent + "%"
            color: battery.fgColor
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
            Behavior on color {
                ColorAnimation { duration: 300; easing.type: Easing.OutQuint }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: battery.activate()
    }
}
