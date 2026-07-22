import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#050A0D"

    property string currentUser: userModel.lastUser
    property int sessionIndex: {
        for (var i = 0; i < sessionModel.rowCount(); i++) {
            var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
            if (name.indexOf("uwsm") !== -1)
                return i
        }
        return sessionModel.lastIndex
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "Contrasena incorrecta"
            password.text = ""
            password.focus = true
        }
        function onLoginSucceeded() {
            errorMessage.text = ""
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
    }

    Column {
        id: loginColumn
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(root.width * 0.86, 560)

        Rectangle {
            id: logoWrap
            anchors.horizontalCenter: parent.horizontalCenter
            width: 124
            height: 124
            radius: 28
            color: "#FFFFFFE0"
            border.color: "#26FFDF66"
            border.width: 1

            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 18
                height: parent.height + 18
                radius: 32
                color: "#26FFDF22"
                z: -1
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 8
                height: parent.height + 8
                radius: 30
                color: "transparent"
                border.color: "#26FFDF66"
                border.width: 1
                z: -1
            }

            Image {
                anchors.centerIn: parent
                width: 96
                height: 96
                source: "v1tr0.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "V1TR0"
            color: "#B9FFF5"
            font.pixelSize: 28
            font.bold: true
        }

        Item {
            width: parent.width
            height: 60

            Rectangle {
                id: glow
                anchors.centerIn: passBox
                width: passBox.width + 16
                height: passBox.height + 16
                radius: height / 2
                color: "#26FFDF24"
            }

            Rectangle {
                id: passBox
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.92, 470)
                height: 50
                radius: height / 2
                color: "#0A171BCC"
                border.width: 2
                border.color: "#26FFDF"
                clip: true

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf023"
                    color: "#D0FFF8"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                }

                TextInput {
                    id: password
                    anchors.fill: parent
                    anchors.leftMargin: 40
                    anchors.rightMargin: 16
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    passwordCharacter: "\u2022"
                    color: "#FFFFFF"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    focus: true

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(root.currentUser, password.text, root.sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }
        }

        Text {
            id: errorMessage
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FF7C93"
            text: ""
            font.pixelSize: 16
        }
    }

    Component.onCompleted: password.forceActiveFocus()
}
