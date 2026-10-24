import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation {
    id: presentation
    Slide {
        Rectangle { anchors.fill: parent; color: "#05264b" }
        Image {
            source: "logo.png"
            width: 160; height: 160
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -30
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 90
            color: "white"
            font.pixelSize: 22
            text: "Pro OS kuruluyor, lütfen bekleyin..."
        }
    }
}
