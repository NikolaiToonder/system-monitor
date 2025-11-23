import QtQuick 2.6

Rectangle {
    id: sidebar
    color: "#1e1e1e"

    signal viewChanged(string viewName)

    property string selectedView: "cpu"

    Column {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            width: parent.width
            height: 80
            color: "#252525"

            Column {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    text: "System"
                    color: "#D1C4A9"
                    font.pixelSize: 24
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Monitor"
                    color: "white"
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#3d3d3d"
        }

        SidebarButton {
            text: "CPU"
            isSelected: sidebar.selectedView === "cpu"
            onClicked: {
                sidebar.selectedView = "cpu"
                sidebar.viewChanged("cpu")
            }
        }

        SidebarButton {
            text: "Memory"
            isSelected: sidebar.selectedView === "memory"
            onClicked: {
                sidebar.selectedView = "memory"
                sidebar.viewChanged("memory")
            }
        }

        SidebarButton {
            text: "GPU"
            isSelected: sidebar.selectedView === "gpu"
            onClicked: {
                sidebar.selectedView = "gpu"
                sidebar.viewChanged("gpu")
            }
        }

        SidebarButton {
            text: "Storage"
            isSelected: sidebar.selectedView === "storage"
            onClicked: {
                sidebar.selectedView = "storage"
                sidebar.viewChanged("storage")
            }
        }

        SidebarButton {
            text: "Network"
            isSelected: sidebar.selectedView === "network"
            onClicked: {
                sidebar.selectedView = "network"
                sidebar.viewChanged("network")
            }
        }

        Item {
            width: parent.width
            height: parent.height - 80 - 1 - (60 * 4) - 40
        }

        // Footer
        Rectangle {
            width: parent.width
            height: 40
            color: "#252525"

            Text {
                text: "v1.0.0"
                color: "#666666"
                font.pixelSize: 12
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: "#3d3d3d"
    }
}
