//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import "WelcomeApp"
import "SidebarApp"
import "WallpaperApp"
import "StatusbarApp"
import "CustomTheme"

ShellRoot {
    // Test IPC tools: qs ipc show

    IpcHandler {
        target: "theme-manager" 
        function reload(): void {
            Theme.reloadTheme()
        }
    }

    WelcomeWindow {}
    SidebarWindow {}
    WallpaperWindow {}
    WallpaperCarousel {}
    // One statusbar per monitor; bars are added/removed as screens come and go.
    Variants {
        model: Quickshell.screens
        delegate: StatusbarWindow {
            required property ShellScreen modelData
            screen: modelData
        }
    }
}