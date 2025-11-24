import QtQuick 2.6
import SystemMonitor 1.0

Item {
    width: 800
    height: 600

    property string currentView: "cpu"  // Track which view is active

    // View mapping - add new views here
    property var viewMap: ({
            "cpu": "CpuView.qml",
            "memory": "MemoryView.qml",
            "gpu": "CpuView.qml"  // Placeholder, will be replaced later
            ,
            "storage": "CpuView.qml"  // Placeholder
            ,
            "network": "CpuView.qml"  // Placeholder
        })

    Row {
        anchors.fill: parent

        // Sidebar (separate component)
        Sidebar {
            id: sidebar
            width: 200
            height: parent.height
            onViewChanged: function (viewName) {
                currentView = viewName;
            }
        }

        // Main content area
        Rectangle {
            width: parent.width - 200
            height: parent.height
            color: "#2b2b2b"

            // Load different views based on selection
            Loader {
                id: contentLoader
                anchors.fill: parent
                source: viewMap[currentView] || "CpuView.qml"
            }
        }
    }
}
