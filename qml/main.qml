import QtQuick 2.6
import SystemMonitor 1.0

Item {
    width: 800
    height: 600

    property string currentView: "cpu"  // Track which view is active

    Row {
        anchors.fill: parent

        // Sidebar (separate component)
        Sidebar {
            id: sidebar
            width: 200
            height: parent.height
            onViewChanged: function(viewName) {
                currentView = viewName
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
                source: {
                    if (currentView === "cpu") return "CpuView.qml"
                    return "CpuView.qml"
                }
            }
        }
    }
}