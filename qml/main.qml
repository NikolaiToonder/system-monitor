import QtQuick 2.6
import SystemMonitor 1.0

Rectangle {
    width: 400
    height: 300
    color: "#2b2b2b"

    CpuMonitor {
        id: cpuMonitor
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "CPU Monitor"
            color: "#00ff00"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "CPU Usage: " + cpuMonitor.cpu_usage.toFixed(1) + "%"
            color: "white"
            font.pixelSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Updates every second"
            color: "#888888"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
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