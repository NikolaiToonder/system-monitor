import QtQuick 2.6
import SystemMonitor 1.0

Rectangle {
    color: "#2b2b2b"

    MemoryMonitor {
        id: memoryMonitor
    }

    Column {
        anchors.centerIn: parent
        spacing: 40

        Text {
            text: "Memory Monitor"
            color: "white"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Memory usage percentage
        Column {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Memory Usage"
                color: "#D1C4A9"
                font.pixelSize: 20
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: memoryMonitor.memory_usage_percent.toFixed(1) + "%"
                color: "white"
                font.pixelSize: 48
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Progress bar
            Rectangle {
                width: 400
                height: 30
                color: "#3d3d3d"
                radius: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width * (memoryMonitor.memory_usage_percent / 100)
                    height: parent.height
                    color: "#D1C4A9"
                    radius: parent.radius

                    Behavior on width {
                        NumberAnimation {
                            duration: 300
                        }
                    }
                }
            }
        }

        // Memory details
        Grid {
            columns: 2
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            columnSpacing: 40
            rowSpacing: 20

            Text {
                text: "Total:"
                color: "#888888"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignRight
            }
            Text {
                text: (memoryMonitor.memory_total / (1024 * 1024 * 1024)).toFixed(2) + " GB"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "Used:"
                color: "#888888"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignRight
            }
            Text {
                text: (memoryMonitor.memory_used / (1024 * 1024 * 1024)).toFixed(2) + " GB"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "Available:"
                color: "#888888"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignRight
            }
            Text {
                text: (memoryMonitor.memory_available / (1024 * 1024 * 1024)).toFixed(2) + " GB"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "Temperature:"
                color: "#888888"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignRight
                visible: memoryMonitor.memory_temp > 0
            }
            Text {
                text: memoryMonitor.memory_temp.toFixed(1) + "°C"
                color: "white"
                font.pixelSize: 18
                font.bold: true
                visible: memoryMonitor.memory_temp > 0
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            memoryMonitor.request_update();
        }
    }
}
