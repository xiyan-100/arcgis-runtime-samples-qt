// [WriteFile Name=RasterLayerService, Category=Layers]
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
import Esri.ArcGISRuntime 100.1
import Esri.ArcGISExtras 1.1

Rectangle {
    id: rootRectangle
    clip: true

    width: 800
    height: 600

    property double scaleFactor: System.displayScaleFactor
    
    MapView {
        anchors.fill: parent
        Map {
            // add a basemap to the map
            Basemap {
                // create the basemap using a raster layer
                RasterLayer {
                    // create the raster layer from an image service raster
                    ImageServiceRaster {
                        url: "http://sampleserver6.arcgisonline.com/arcgis/rest/services/NLCDLandCover2001/ImageServer"
                    }
                }
            }
        }
    }
}
