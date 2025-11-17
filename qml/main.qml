import QtQuick 2.6

Item {
    width: 400
    height: 300

    Rectangle {
        anchors.fill: parent
        color: "#2b2b2b"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Hello from Rust + Qt!"
                font.pixelSize: 24
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 100
                height: 40
                color: "#4a4a4a"
                border.color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "Click me!"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parent.parent.parent.children[0].text = "Button clicked!"
                    }
                }
            }
        }
    }
}