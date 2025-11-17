import QtQuick 2.6
import SystemMonitor 1.0

Rectangle {
    color: "#2b2b2b"

    CpuMonitor {
        id: cpuMonitor
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "CPU Monitor"
            color: "white"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            text: "Usage: " + cpuMonitor.cpu_usage.toFixed(1) + "%"
            color: "white"
            font.pixelSize: 24
        }

        Text {
            text: "Usage: alo"
            color: "white"
            font.pixelSize: 24
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