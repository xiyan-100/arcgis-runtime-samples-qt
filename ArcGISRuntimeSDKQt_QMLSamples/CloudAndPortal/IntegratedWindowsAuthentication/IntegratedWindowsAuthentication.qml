// [WriteFile Name=IntegratedWindowsAuthentication, Category=CloudAndPortal]
// [Legal]
// Copyright 2019 Esri.

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
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Esri.ArcGISRuntime 100.6
import Esri.ArcGISRuntime.Toolkit.Dialogs 100.6

Rectangle {
    id: rootRectangle
    clip: true
    width: 800
    height: 600

    readonly property url arcgis_url: "http://www.arcgis.com"
    property var portalItem
    property var portalItemListModel
    property var listModelForComboBox : []

    MapView {
        id: mapView
        anchors.fill: parent

        Map {
            BasemapTopographic {}
        }
    }

    Portal {
        id: publicPortal

        onLoadStatusChanged: {
            console.log("loading public");
            if (loadStatus === Enums.LoadStatusFailedToLoad)
                retryLoad();

            if (loadStatus !== Enums.LoadStatusLoaded) {
                return;
            }
        }


    }

//    Component {
//        id: webmapDelegate
//        Rectangle {
//            id: tempItem
//            height: childrenRect.height
//            width: portalLayoutRect.width
//            color: "#00000000"
//            Text {
//                id: outputString
//                text: title
//                horizontalAlignment: Text.AlignHCenter
//                color: "white"
//            }

//            MouseArea {
//                anchors.fill: parent
//                onClicked: webmapsList.currentIndex = index;
//                onDoubleClicked: loadSelectedWebmap(webmapsList.model.get(index));
//            }
//        }
//    }

//    Component {
//        id: highlightDelegate

//        Rectangle {
//            z: 110
////            width: webmapsList.width
//            width: parent.width

//            color: "orange"
//            radius: 4

////            Text {
////                anchors {
////                    fill: parent
////                    margins: 10
////                }
////                //not needed?
////                //text: webmapsList.model.count > 0 ? webmapsList.model.get(webmapsList.currentIndex).title : ""
////                font.bold: true
////                elide: Text.ElideRight
////                wrapMode: Text.Wrap
////                color: "white"
////                horizontalAlignment: Text.AlignHCenter
////            }
//        }
//    }

    Rectangle {
        id: portalLayoutRect
        anchors {
            margins: 5
//            horizontalCenter: parent.horizontalCenter
            left: parent.left
            top: parent.top
        }
        width: childrenRect.width
        height: childrenRect.height
        color: "#000000"
        opacity: .75
        radius: 5

        ColumnLayout {
            TextField {
                id: securePortalUrl
                Layout.fillWidth: true
                Layout.margins: 3
//                text: qsTr("Enter portal url")
                text: qsTr("https://portaliwads.ags.esri.com/gis/")
            }

            Row {
                Layout.fillWidth: true
                Layout.margins: 3
                spacing: 4
                Button {
                    id: searchPublic
                    text: qsTr("Search Public")
                    onClicked: {
                        searchPortal(arcgis_url);
//                        webmapsList.visible = true;
//                        loadSelectedWebmapBtn.visible = true;
                    }
                }
                Button {
                    id: searchSecure
                    text: qsTr("Search Secure")
                    onClicked: {
//                        console.log(securePortalUrl.text);
                        searchPortal(securePortalUrl.text);
//                        webmapsList.visible = true;
//                        loadSelectedWebmapBtn.visible = true;
                    }
                }
            }

            ComboBox {
                id:webmapsList
                Layout.margins: 3
                Layout.fillWidth: true
                model: null
                visible: false
            }








// switching to combobox
//            ListView {
//                id: webmapsList
//                height: 155
//                Layout.margins: 3
////                delegate: webmapDelegate
//                delegate: Rectangle {
//                    id: tempItem
//                    height: childrenRect.height
//                    width: portalLayoutRect.width
//                    color: "#00000000"
//                    Text {
//                        id: outputString
//                        text: title
//                        horizontalAlignment: Text.AlignHCenter
//                        color: "white"
//                    }

//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: webmapsList.currentIndex = index;
//                        onDoubleClicked: loadSelectedWebmap(webmapsList.model.get(index));
//                    }
//                }
//                highlightFollowsCurrentItem: true
//                highlight: highlightDelegate
//                model: null
//            }

            Button {
                id: loadSelectedWebmapBtn
                text: qsTr("Load Web Map")
                Layout.fillWidth: true
                Layout.margins: 3
                visible: false
                onClicked: {
                    loadSelectedWebmap(portalItemListModel.get(webmapsList.currentIndex));
                }
            }
        }
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        running: publicPortal.loadStatus == Enums.LoadStatusLoading
    }

    PortalQueryParametersForItems {
        id: webmapQuery
        types: [ Enums.PortalItemTypeWebMap ]
        // check to see if you can limit results
    }

    function searchPortal (portalUrl) {
        var pubPortal = ArcGISRuntimeEnvironment.createObject("Portal", {url: portalUrl});
        pubPortal.loadStatusChanged.connect(function() {
            if (pubPortal.loadStatus === Enums.LoadStatusFailedToLoad) {
                webMapMsg.text = pubPortal.loadError.message;
                webMapMsg.visible = true;
                indicator.running = false;
                return;
            }

            if (pubPortal.loadStatus === Enums.LoadStatusLoaded){
                pubPortal.findItems(webmapQuery);
                return;
            }

        });

        pubPortal.findItemsStatusChanged.connect(function() {

            if ( pubPortal.findItemsStatus === Enums.TaskStatusCompleted ) {
                indicator.running = false;
                portalItemListModel = pubPortal.findItemsResult.itemResults;
                var index = 0
                var error = portalItemListModel.forEach(function(prtlItem){
                    listModelForComboBox[index] = prtlItem.title;
                    index++;
                });
                if (error) {
                    webMapMsg.text = error.message;
                    webMapMsg.visible = true;
                }
                webmapsList.model = listModelForComboBox;

                webmapsList.visible = true;
                loadSelectedWebmapBtn.visible = true;
            }

        });
        pubPortal.load();
        indicator.running = true;
    }

    function loadSelectedWebmap(selectedWebmap) {
        portalItem = selectedWebmap;

        portalItem.loadStatusChanged.connect(createMap);
        portalItem.loadErrorChanged.connect( function() {
            webMapMsg.text = portalItem.loadError.message;
            webMapMsg.visible = true;
        });
        portalItem.load();
        if (portalItem.loadStatus === Enums.LoadStatusLoaded){
            createMap();
        }
    }

    function createMap() {
        if (portalItem.loadStatus !== Enums.LoadStatusLoaded)
            return;

        mapView.map = ArcGISRuntimeEnvironment.createObject("Map", {"item": portalItem});

        mapView.map.loadStatusChanged.connect(assignWebmap);
        mapView.map.loadErrorChanged.connect( function() {
            webMapMsg.text = mapView.map.loadError.message;
            webMapMsg.visible = true;
        });

        mapView.map.load();
    }

    function assignWebmap() {
        if (mapView.map.loadStatus !== Enums.LoadStatusLoaded)
            return;

        //webmapsList.visible = false;
        mapView.visible = true;
    }


    // Uncomment this section when running as standalone application
    AuthenticationView {
        authenticationManager: AuthenticationManager
    }

    //! [PortalUserInfo create portal]

    Dialog {
        id: webMapMsg
        modal: true
        x: Math.round(parent.width - width) / 2
        y: Math.round(parent.height - height) / 2
        standardButtons: Dialog.Ok
        title: qsTr("Could not load web map!")
        property alias text : textLabel.text
        Text {
            id: textLabel
        }
        onAccepted: visible = false;
    }
}
