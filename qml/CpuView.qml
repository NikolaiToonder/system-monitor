import QtQuick 2.6
import SystemMonitor 1.0

Rectangle {
    color: "#2b2b2b"

    property string displayMode: "usage"  // "usage" or "temperature"

    CpuMonitor {
        id: cpuMonitor
    }

    Column {
        anchors.fill: parent
        spacing: 0

        // Top bar with mode selection
        Rectangle {
            width: parent.width
            height: 60
            color: "#1e1e1e"

            Row {
                anchors.centerIn: parent
                spacing: 0

                Rectangle {
                    width: 150
                    height: 40
                    color: displayMode === "usage" ? "#D1C4A9" : "#3d3d3d"
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        onClicked: displayMode = "usage"
                        cursorShape: Qt.PointingHandCursor
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Usage"
                        color: displayMode === "usage" ? "#1e1e1e" : "#888888"
                        font.pixelSize: 16
                        font.bold: displayMode === "usage"
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                Rectangle {
                    width: 150
                    height: 40
                    color: displayMode === "temperature" ? "#D1C4A9" : "#3d3d3d"
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        onClicked: displayMode = "temperature"
                        cursorShape: Qt.PointingHandCursor
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Temperature"
                        color: displayMode === "temperature" ? "#1e1e1e" : "#888888"
                        font.pixelSize: 16
                        font.bold: displayMode === "temperature"
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }

        // Main content area
        Item {
            width: parent.width
            height: parent.height - 60

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
                    text: displayMode === "usage" ? "Average Usage: " + cpuMonitor.cpu_usage.toFixed(1) + "%" : "Average Temperature: " + cpuMonitor.cpu_temp.toFixed(1) + "°C"
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
                        model: displayMode === "usage" ? cpuMonitor.cpu_usage_core : cpuMonitor.cpu_temp_core

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
                                text: {
                                    if (displayMode === "usage") {
                                        return parent.hovered ? "Core " + index + ":\n" + modelData.toFixed(1) + "%" : modelData.toFixed(1) + "%";
                                    } else {
                                        return parent.hovered ? "Core " + index + ":\n" + modelData.toFixed(1) + "°C" : modelData.toFixed(1) + "°C";
                                    }
                                }
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
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }
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
            cpuMonitor.request_update();
        }
    }
}
