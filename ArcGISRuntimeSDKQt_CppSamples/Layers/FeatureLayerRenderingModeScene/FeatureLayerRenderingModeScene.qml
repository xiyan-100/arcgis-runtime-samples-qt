// [WriteFile Name=FeatureLayerRenderingModeScene, Category=Layers]
// [Legal]
// Copyright 2017 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import Esri.Samples 1.0
import Esri.ArcGISExtras 1.1

FeatureLayerRenderingModeSceneSample {
    id: rootRectangle
    clip: true
    width: 800
    height: 600

    property real scaleFactor: (Screen.logicalPixelDensity * 25.4) / (Qt.platform.os === "windows" || Qt.platform.os === "linux" ? 96 : 72)

    SceneView {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: parent.height / 2
        objectName: "topSceneView"

        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                margins: 5 * scaleFactor
            }
            color: "white"
            radius: 5 * scaleFactor
            width: 200 * scaleFactor
            height: 30 * scaleFactor

            Text {
                anchors.centerIn: parent
                text: "Rendering Mode Static"
            }
        }
    }

    SceneView {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: parent.height / 2
        objectName: "bottomSceneView"

        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                margins: 5 * scaleFactor
            }
            color: "white"
            radius: 5 * scaleFactor
            width: 200 * scaleFactor
            height: 30 * scaleFactor

            Text {
                anchors.centerIn: parent
                text: "Rendering Mode Dynamic"
            }
        }
    }

    Button {
        anchors {
            left: parent.left
            top: parent.top
            margins: 10 * scaleFactor
        }
        property string startText: "Start Animation"
        property string stopText: "Stop Animation"
        text: startText
        onClicked: {
            if (text === startText) {
                startAnimation();
                text = stopText;
            } else {
                stopAnimation();
                text = startText;
            }
        }
    }
}
