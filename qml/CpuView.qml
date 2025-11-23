import QtQuick 2.6
import SystemMonitor 1.0


Rectangle {
    color: "#2b2b2b"

    CpuMonitor {
        id: cpuMonitor
    }

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "CPU Monitor"
            color: "white"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Average Usage: " + cpuMonitor.cpu_usage.toFixed(1) + "%"
            color: "white"
            font.pixelSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Grid of CPU cores (max 6 per row)
        Grid {
            columns: 6
            spacing: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: cpuMonitor.cpu_usage_core

                Rectangle {
                    width: 80
                    height: 80
                    color: "#3d3d3d"
                    border.color: "#D1C4A9"
                    border.width: 2

                    property bool hovered: false

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                    }
                    //will display additional information if hovered
                    Text {
                        anchors.centerIn: parent
                        text: parent.hovered 
                            ? "Core " + index + ":\n" + modelData.toFixed(1) + "%"
                            : modelData.toFixed(1) + "%"
                        color: "white"
                        font.pixelSize: parent.hovered ? 14 : 18
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Hover effect
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        opacity: parent.hovered ? 0.1 : 0
                        radius: parent.radius
                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuMonitor.request_update()
        }
    }
}