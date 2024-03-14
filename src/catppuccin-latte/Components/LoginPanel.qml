import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
  property var user: userField.text
  property var password: passwordField.text
  property var session: sessionPanel.session
  property var inputHeight: Screen.height * 0.032
  property var inputWidth: Screen.width * 0.16
  Rectangle {
    id: loginBackground
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    height: inputHeight * 5.3
    width: inputWidth * 1.2
    radius: 5
    visible: config.LoginBackground == "true" ? true : false
    color: config.mantle
  }
  Column {
    spacing: 8
    anchors {
      bottom: parent.bottom
      right: parent.right
    }
    SessionPanel {
      id: sessionPanel
    }
    z: 5
  }
  Column {
    spacing: 32
    z: 5
    width: inputWidth
    anchors {
      verticalCenter: parent.verticalCenter
      horizontalCenter: parent.horizontalCenter
    }
    Image {
      anchors.horizontalCenter: parent.horizontalCenter
      height: Screen.width * 0.05
      width: Screen.width * 0.05
      fillMode: Image.PreserveAspectFit
      source: config.Logo
    }
    Column {
      spacing: 8
      width: parent.width
      UserField {
        id: userField
        height: inputHeight
        width: parent.width
      }
      PasswordField {
        id: passwordField
        height: inputHeight
        width: parent.width
        onAccepted: loginButton.clicked()
      }
    }
    Column {
      spacing: 8
      width: parent.width
      Button {
        id: loginButton
        height: inputHeight
        width: parent.width
        enabled: user != "" && password != "" ? true : false
        hoverEnabled: true
        contentItem: Text {
          id: buttonText
          renderType: Text.NativeRendering
          font {
            family: config.Font
            pointSize: config.FontSize
            bold: true
          }
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: config.crust
          text: "Login"
        }
        background: Rectangle {
          id: buttonBackground
          color: "#254a8a"
          radius: 3
        }
        states: [
          State {
            name: "pressed"
            when: loginButton.down
            PropertyChanges {
              target: buttonBackground
              color: config.teal
            }
            PropertyChanges {
              target: buttonText
            }
          },
          State {
            name: "hovered"
            when: loginButton.hovered
            PropertyChanges {
              target: buttonBackground
              color: config.teal
            }
            PropertyChanges {
              target: buttonText
            }
          },
          State {
            name: "enabled"
            when: loginButton.enabled
            PropertyChanges {
              target: buttonBackground
            }
            PropertyChanges {
              target: buttonText
            }
          }
        ]
        transitions: Transition {
          PropertyAnimation {
            properties: "color"
            duration: 300
          }
        }
        onClicked: {
          errorMessage.text = ""
          sddm.login(user, password, session)
        }
      }
      Text {
        id: errorMessage
        text: ""
        color: config.red
        font.italic: true
        font.pointSize: config.FontSize
      }
    }
  }
  Connections {
    target: sddm

    function onLoginFailed() {
      passwordField.text = ""
      passwordField.focus = true
      errorMessage.text = "Login failed"
    }
  }
}
