import QtQuick 2.6

Rectangle {
    id: button
    width: parent.width
    height: 60
    color: isSelected ? "#3d3d3d" : "transparent"

    property string text: ""
    property bool isSelected: false
    signal clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }

    Rectangle {
        width: 4
        height: parent.height
        color: "#D1C4A9"
        visible: isSelected
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 20
        spacing: 15
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: 24
            height: 24
            radius: 4
            color: isSelected ? "#D1C4A9" : "#666666"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: button.text
            color: isSelected ? "white" : "#888888"
            font.pixelSize: 16
            font.bold: isSelected
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: mouseArea.containsMouse && !isSelected ? 0.05 : 0
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }
}
