import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import Aurora.Controls 1.0
import io.thp.pyotherside 1.5

Page {
    id: page

    // values transmitted from FirstPage.qml
    property var tempImageFolderPath
    property var inputPathPy
    property var inputImageWidth
    property var outputPathPy
    property var filterSourceFolder
    property var previewImageRatio
    property var handleWidth
    property var toolsDrawingColorFrame
    property var opacityEdges
    property var paintToolColor
    property var symbolSourceFolder
    property var previewBaseImagePath

    // values for preview image
    property var previewBaseImageWidth : idPreviewImage.width
    property var currentEffectName : "original"
    property var spotType

    // variables for UI
    property var cubeFilePath : ""
    property var cubeFileName : ""
    property bool blockerApply : false
    property var ratioWidthOriginal2Base
    property bool processing

    allowedOrientations: Orientation.All

    Component.onCompleted: {
        py.createPreviewBaseImage()
    }

    Python {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../py'))
            importModule('graphx', function () { })

            // Handlers = Signals to do something in QML whith received Infos from pyotherside
            setHandler('previewImageCreated', function( previewPath ) {
                idPreviewImage.source = "" // Patch: make sure not to get old content ever
                idPreviewImage.source = encodeURI( previewPath )
                idOriginalOverlayImage.source = previewBaseImagePath
                page.processing = false
                blockerApply = false
                idPreviewImage.visible = true
                ratioWidthOriginal2Base = inputImageWidth / previewBaseImageWidth
            });
        }

        // Functions affecting original image

        function filtersEffectsMiddleStepFunction() {
            var coalValue = idFxSliderCoalBlur.value
            var blurValue = idFxSliderBlur.value
            var centerFocusValue = idFxSliderCentralFocus.value
            var miniatureBlurValue = idFxSliderMiniatureBlur.value
            var miniatureColorValue = idFxSliderMiniatureColor.value
            var addFrameValue = idFxSliderAddFrame.value
            var brushSize = idFxSliderDrawing.value
            var quantizeColors = idFxSliderQuantize.value
            
            const targetColor2Alpha = idComboBoxAlphaColor.currentIndex === 0 ? "white" : "black"
            
            var alphaTolerance = idFxSliderAlphaTolerance.value
            var opacityValue = idFxSliderOpacity.value
            
            const colorExtractARGB = idComboBoxColorExtract.currentIndex === 0
                                     ? "R"
                                     : idComboBoxColorExtract.currentIndex === 1
                                       ? "G"
                                       : "B"

            const channelExtractARGB = idComboBoxChannelExtract.currentIndex === 0
                                       ? "R"
                                       : idComboBoxChannelExtract.currentIndex === 1
                                         ? "G"
                                         : idComboBoxChannelExtract.currentIndex === 2
                                           ? "B"
                                           : "A"

            var unsharpRadiusMask = idFxUnsharpRadiusMask.value
            var unsharpPercentMask = idFxUnsharpPercentMask.value
            var unsharpThresholdMask = idFxUnsharpThresholdMask.value
            var brightspotSize = idFxSliderBrightspotSize.value

            call("graphx.filtersEffectsMiddleStepFunction", [ currentEffectName, coalValue, blurValue, centerFocusValue,
                                                              miniatureBlurValue, miniatureColorValue, addFrameValue, 
                                                              brushSize, quantizeColors, targetColor2Alpha, 
                                                              alphaTolerance, opacityValue, colorExtractARGB, 
                                                              channelExtractARGB, unsharpRadiusMask, unsharpPercentMask,
                                                              unsharpThresholdMask, brightspotSize ])
            
            pageStack.pop()
        }

        // Functions affecting preview image

        function createPreviewBaseImage () {
            page.processing = true
            blockerApply = true
            call("graphx.createPreviewBaseImage", [ inputPathPy, previewBaseImagePath, previewBaseImageWidth ])
        }

        function autocontrastFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.autocontrastFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function stretchContrastFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.stretchContrastFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function blackWhiteFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.blackWhiteFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function coalFilterFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var blurRadius = Math.round( idFxSliderCoalBlur.value / ratioWidthOriginal2Base)
            call("graphx.coalFilterFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, blurRadius ])
        }

        function grayscaleFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.grayscaleFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function invertFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.invertFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function equalizeFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.equalizeFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function solarizeFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.solarizeFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function modedrawingFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var brushSize = Math.round( idFxSliderDrawing.value / ratioWidthOriginal2Base)
            call("graphx.modedrawingFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, brushSize ])
        }

        function posterizeFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.posterizeFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function blurFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var blurFactor =  Math.round( idFxSliderBlur.value / ratioWidthOriginal2Base)
            call("graphx.blurFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, blurFactor ])
        }

        function smoothSurfaceFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var smoothingStrength = "strong"
            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, smoothingStrength ]
            call("graphx.smoothSurfaceFunction", args)
        }

        function centerFocusFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var alphaMaskPath = symbolSourceFolder + "alphaMaskCircleSmall.png"
            var radiusEdgeBlur = Math.round( idFxSliderCentralFocus.value / ratioWidthOriginal2Base)
            var enhanceColorFaktor = 1
            var enhanceContrastFaktor = 1
            var addExtraBlurAroundPath = "none"

            call("graphx.miniatureFocusFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, 
                                                    alphaMaskPath, radiusEdgeBlur, enhanceColorFaktor, 
                                                    enhanceContrastFaktor, addExtraBlurAroundPath ])
        }

        function miniatureFocusFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var alphaMaskPath = symbolSourceFolder + "alphaMaskStandard.png"
            var radiusEdgeBlur = Math.round( idFxSliderMiniatureBlur.value / ratioWidthOriginal2Base)
            var enhanceColorFaktor = Math.round( idFxSliderMiniatureColor.value )
            var enhanceContrastFaktor = 1.3
            var addExtraBlurAroundPath = symbolSourceFolder + "alphaMaskCircleSmall.png"

            call("graphx.miniatureFocusFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, 
                                                    alphaMaskPath, radiusEdgeBlur, enhanceColorFaktor, 
                                                    enhanceContrastFaktor, addExtraBlurAroundPath ])
        }

        function edgeenhanceFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.edgeenhanceFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function unsharpmaskFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var radiusMask = idFxUnsharpRadiusMask.value // 3 //2
            var percentMask = idFxUnsharpPercentMask.value // 150 //150
            var thresholdMask = idFxUnsharpThresholdMask.value // 4 //3

            call("graphx.unsharpmaskFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, radiusMask, 
                                                 percentMask, thresholdMask ])
        }

        function findedgesFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var fileTargetType = inputPathPy.slice(inputPathPy.length - 4)

            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, fileTargetType ]
            call("graphx.findedgesFunction", args)
        }
        
        function contourFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.contourFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }
        
        function embossFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            call("graphx.embossFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath ])
        }

        function addFrameFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var addFrameValue = Math.round( idFxSliderAddFrame.value / ratioWidthOriginal2Base)
            
            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, addFrameValue, paintToolColor ]
            call("graphx.addFrameFunction", args)
        }

        function tintWithColorFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var factorBrightnessTint = 1.2

            const args = [ targetImage, inputPathPy, outputPathPy, paintToolColor, factorBrightnessTint ]
            call("graphx.tintWithColorFunction", args)
        }

        function quantizeFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var colorsAmount = idFxSliderQuantize.value
            call("graphx.quantizeFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, colorsAmount ])
        }

        function colorToAlphaFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var targetColorTolerance = idFxSliderAlphaTolerance.value //"30"
            var targetColor2Alpha = idComboBoxAlphaColor.currentIndex === 0 ? "white" : "black"

            call("graphx.colorToAlphaFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, 
                                                  targetColor2Alpha, targetColorTolerance ])
        }

        function addAlphaFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var percentAlpha = idFxSliderOpacity.value
            call("graphx.addAlphaFunction", [ targetImage, previewBaseImagePath, previewImageEffectPath, percentAlpha ])
        }

        function extractColorFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var colorExtractARGB = idComboBoxColorExtract.currentIndex === 0 
                                   ? "R"
                                   : idComboBoxColorExtract.currentIndex === 1 
                                     ? "G" 
                                     : "B"
            
            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, colorExtractARGB ]
            call("graphx.extractColorFunction", args)
        }

        function extractChannelFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            var channelExtractARGB = idComboBoxChannelExtract.currentIndex === 0
                                     ? "R"
                                     : idComboBoxChannelExtract.currentIndex === 1
                                       ? "G"
                                       : idComboBoxChannelExtract.currentIndex === 2
                                         ? "B"
                                         : "A"
            
            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, channelExtractARGB ]
            call("graphx.extractChannelFunction", args)
        }

        function brightspotFilterFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"

            var spotType = currentEffectName === "fxMinFilter"
                           ? "min"
                           : currentEffectName === "fxMaxFilter"
                             ? "max"
                             : currentEffectName === "fxMedFilter"
                               ? "med"
                               : undefined
            
            var brightspotSize = Math.round( idFxSliderBrightspotSize.value / ratioWidthOriginal2Base)

            // check that it stays an odd number, even numbers do not work in PILLOW
            if (brightspotSize % 2 === 0 ) {
                brightspotSize = brightspotSize + 1
            }

            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, spotType, brightspotSize ]
            call("graphx.brightspotFilterFunction", args)
        }

        function fishEyeFunction() {
            var targetImage = "preview"
            var previewImageEffectPath = tempImageFolderPath + "preview" + "-" + currentEffectName + ".tmp.png"
            
            const args = [ targetImage, previewBaseImagePath, previewImageEffectPath, paintToolColor ]
            call("graphx.fishEyeFunction", args)
        }

        onError: console.log('python error: ' + traceback);
        onReceived: console.log('got message from python: ' + data);
    } // end Python

    AppBar {
        id: appBar

        headerText: qsTr("Effects bench")
        subHeaderText: qsTr("Apply effects")

        AppBarSpacer { }

        AppBarButton {
            icon.source: "image://theme/icon-splus-accept"
            enabled: !page.blockerApply && idComboBoxPresets.currentIndex !== 0 && !page.processing

            onClicked: py.filtersEffectsMiddleStepFunction()
        }
    }

    BusyLabel {
        text: qsTr("Applying changes")
        running: page.blockerApply || page.processing
    }

    SilicaFlickable {
        id: listView

        anchors{
            fill: parent
            topMargin: appBar.height
        }

        contentHeight: columnMoods.height
        topMargin: Theme.paddingLarge
        bottomMargin: topMargin
        opacity: page.blockerApply || page.processing ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            FadeAnimation { }
        }

        VerticalScrollDecorator { }

        Column {
            id: columnMoods

            width: page.width

            ComboBox {
                id: idComboBoxPresets
                
                label: qsTr("Effect")

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("original")
                    }
                    MenuItem {
                        text: qsTr("auto contrast")
                    }
                    MenuItem {
                        text: qsTr("stretch contrast")
                    }
                    MenuItem {
                        text: qsTr("dithering")
                    }
                    MenuItem {
                        text: qsTr("coal drawing")
                    }
                    MenuItem {
                        text: qsTr("grayscale")
                    }
                    MenuItem {
                        text: qsTr("invert colors")
                    }
                    MenuItem {
                        text: qsTr("equalize colors")
                    }
                    MenuItem {
                        text: qsTr("solarize")
                    }
                    MenuItem {
                        text: qsTr("brush art")
                    }
                    MenuItem {
                        text: qsTr("posterize")
                    }
                    MenuItem {
                        text: qsTr("blur image")
                    }
                    MenuItem {
                        text: qsTr("smooth surface")
                    }
                    MenuItem {
                        text: qsTr("central focus")
                    }
                    MenuItem {
                        text: qsTr("miniature world")
                    }
                    MenuItem {
                        text: qsTr("enhance edges")
                    }
                    MenuItem {
                        text: qsTr("digital unsharp masking")
                    }
                    MenuItem {
                        text: qsTr("find edges")
                    }
                    MenuItem {
                        text: qsTr("find contour")
                    }
                    MenuItem {
                        text: qsTr("emboss")
                    }
                    MenuItem {
                        text: qsTr("add current colored frame")
                    }
                    MenuItem {
                        text: qsTr("tint with current color")
                    }
                    MenuItem {
                        text: qsTr("reduce colors")
                    }
                    MenuItem {
                        text: qsTr("change opacity")
                    }
                    MenuItem {
                        text: qsTr("create alpha from")
                    }
                    MenuItem {
                        text: qsTr("extract color")
                    }
                    MenuItem {
                        text: qsTr("extract channel")
                    }

                    MenuItem {
                        text: qsTr("minFilter (bright spots darker)")
                    }
                    MenuItem {
                        text: qsTr("maxFilter (dark spots brighter)")
                    }
                    MenuItem {
                        text: qsTr("mediumFilter")
                    }
                    MenuItem {
                        text: qsTr("fishEye")
                    }
                }

                onCurrentIndexChanged: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            Image {
                id: idPreviewImage
                
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                    rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                }

                fillMode: Image.PreserveAspectFit
                source: ""
                cache: false
                visible: false

                Item {
                    id: idOriginalImageArea
                    
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width / 2
                    clip: true
                    
                    Image {
                        id: idOriginalOverlayImage
                    
                        source: ""
                        cache: false
                    }
                }

                Item {
                    id: idHandlesPreviewOriginal
                    
                    anchors.fill: parent
                    
                    Rectangle {
                        id: rectDrag1
                        
                        x: parent.width / 2 - handleWidth / 2
                        y: parent.height / 2 - handleWidth / 2
                        radius: handleWidth
                        width: handleWidth
                        height: handleWidth
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges

                        MouseArea {
                            id: dragArea1

                            preventStealing: true
                            anchors.centerIn: parent
                            width: parent.width * 3
                            height: parent.height * 3

                            drag {
                                target: parent
                                axis: Drag.XAxis
                                minimumX: 0 - handleWidth / 2
                                maximumX: idHandlesPreviewOriginal.width - handleWidth / 2
                            }

                            onPositionChanged: idOriginalImageArea.width = (rectDrag1.x + handleWidth/2)
                        }
                        Rectangle {
                            id: idVerticalLine
                            
                            color: toolsDrawingColorFrame
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: 5
                            height: idPreviewImage.height + 1
                        }
                    }
                }


            }

            Rectangle {
                width: parent.width
                height: Theme.paddingLarge * 1.5
                color: "transparent"
            }

            Slider {
                id: idFxSliderCoalBlur
                visible: idComboBoxPresets.currentIndex === 4
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 100
                value: 20
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("coal") + " " + idFxSliderCoalBlur.value //"blur"
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderDrawing
                visible: idComboBoxPresets.currentIndex === 9
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 50
                value: 9
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("brush size") + " " + idFxSliderDrawing.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderBlur
                visible: idComboBoxPresets.currentIndex === 11
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 50
                value: 5
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("blur") + " " + idFxSliderBlur.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderCentralFocus
                visible: idComboBoxPresets.currentIndex === 13
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 20
                value: 6
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("blur") + " " + idFxSliderCentralFocus.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderMiniatureBlur
                visible: idComboBoxPresets.currentIndex === 14
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 20
                value: 5
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("blur") + " " + idFxSliderMiniatureBlur.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderMiniatureColor
                visible: idComboBoxPresets.currentIndex === 14
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 0
                maximumValue: 2
                value: 1.75
                stepSize: 0.02
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("color") + " " + idFxSliderMiniatureColor.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderAddFrame
                visible: idComboBoxPresets.currentIndex === 20
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 100
                value: 10
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("frame") + " " + idFxSliderAddFrame.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderQuantize
                visible: idComboBoxPresets.currentIndex === 22
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 2
                maximumValue: 256
                value: 256
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("amount colors") + " " + idFxSliderQuantize.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderOpacity
                visible: idComboBoxPresets.currentIndex === 23
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 0
                maximumValue: 100
                value: 100
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("opacity") + " " + idFxSliderOpacity.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            ComboBox {
                id: idComboBoxAlphaColor
                visible: idComboBoxPresets.currentIndex === 24
                x: Theme.paddingMedium
                width: parent.width - Theme.paddingMedium
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("white")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("black")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
                onCurrentIndexChanged: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
            }
            Slider {
                id: idFxSliderAlphaTolerance
                visible: idComboBoxPresets.currentIndex === 24
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 0
                maximumValue: 256
                value: 30
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("tolerance") + " " + idFxSliderAlphaTolerance.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            ComboBox {
                id: idComboBoxColorExtract
                visible: idComboBoxPresets.currentIndex === 25
                x: Theme.paddingMedium
                width: parent.width - Theme.paddingMedium
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("red")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("green")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("blue")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
                onCurrentIndexChanged: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
            }
            ComboBox {
                id: idComboBoxChannelExtract
                visible: idComboBoxPresets.currentIndex === 26
                x: Theme.paddingMedium
                width: parent.width - Theme.paddingMedium
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("red")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("green")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("blue")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                    MenuItem {
                        text: qsTr("alpha")
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
                onCurrentIndexChanged: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
            }
            Slider {
                id: idFxUnsharpRadiusMask
                visible: idComboBoxPresets.currentIndex === 16
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 0.5
                maximumValue: 5
                value: 3
                stepSize: 0.5
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("radius") + " " + idFxUnsharpRadiusMask.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxUnsharpPercentMask
                visible: idComboBoxPresets.currentIndex === 16
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 5
                maximumValue: 250
                value: 150
                stepSize: 5
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("percent") + " " + idFxUnsharpPercentMask.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxUnsharpThresholdMask
                visible: idComboBoxPresets.currentIndex === 16
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 1
                maximumValue: 10
                value: 3
                stepSize: 1
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("threshold") + " " + idFxUnsharpThresholdMask.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
            Slider {
                id: idFxSliderBrightspotSize
                visible: (idComboBoxPresets.currentIndex === 27 || idComboBoxPresets.currentIndex === 28 || idComboBoxPresets.currentIndex === 29) ? true : false
                enabled: blockerApply === false
                width: parent.width
                height: Theme.itemSizeSmall * 1.1
                leftMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                rightMargin: Theme.paddingLarge + Theme.paddingMedium + Theme.paddingSmall
                minimumValue: 3
                maximumValue: 15
                value: 3
                stepSize: 2
                smooth: true
                onReleased: {
                    blockerApply = true
                    previewImageEffectPicker()
                }
                Label {
                    text: qsTr("size") + " " + idFxSliderBrightspotSize.value
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: -Theme.paddingSmall
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: Theme.paddingLarge * 1.5
                color: "transparent"
            }

        } // end Column
    } // end Silica Flickable

    function previewImageEffectPicker () {
        page.processing = true
        if (idComboBoxPresets.currentIndex === 0) {
            currentEffectName = "original"
            idPreviewImage.source = ""
            idPreviewImage.source = previewBaseImagePath
            page.processing = false
        }
        else if (idComboBoxPresets.currentIndex === 1) {
            currentEffectName = "fxAutoContrast"
            py.autocontrastFunction()
        }
        else if (idComboBoxPresets.currentIndex === 2) {
            currentEffectName = "fxStretchContrast"
            py.stretchContrastFunction()
        }
        else if (idComboBoxPresets.currentIndex === 3) {
            currentEffectName = "fxDither"
            py.blackWhiteFunction()
        }
        else if (idComboBoxPresets.currentIndex === 4) {
            currentEffectName = "fxCoal"
            py.coalFilterFunction()
        }        
        else if (idComboBoxPresets.currentIndex === 5) {
            currentEffectName = "fxGray"
            py.grayscaleFunction()
        }
        else if (idComboBoxPresets.currentIndex === 6) {
            currentEffectName = "fxInvert"
            py.invertFunction()
        }
        else if (idComboBoxPresets.currentIndex === 7) {
            currentEffectName = "fxEqualize"
            py.equalizeFunction()
        }
        else if (idComboBoxPresets.currentIndex === 8) {
            currentEffectName = "fxSolarize"
            py.solarizeFunction()
        }
        else if (idComboBoxPresets.currentIndex === 9) {
            currentEffectName = "fxDrawing"
            py.modedrawingFunction()
        }
        else if (idComboBoxPresets.currentIndex === 10) {
            currentEffectName = "fxPosterize"
            py.posterizeFunction()
        }
        else if (idComboBoxPresets.currentIndex === 11) {
            currentEffectName = "fxBlur"
            py.blurFunction()
        }
        else if (idComboBoxPresets.currentIndex === 12) {
            currentEffectName = "fxSmoothSurface"
            py.smoothSurfaceFunction()
        }
        else if (idComboBoxPresets.currentIndex === 13) {
            currentEffectName = "fxCentralFocus"
            py.centerFocusFunction()
        }
        else if (idComboBoxPresets.currentIndex === 14) {
            currentEffectName = "fxMiniature"
            py.miniatureFocusFunction()
        }
        else if (idComboBoxPresets.currentIndex === 15) {
            currentEffectName = "fxEnhanceEdges"
            py.edgeenhanceFunction()
        }
        else if (idComboBoxPresets.currentIndex === 16) {
            currentEffectName = "fxUnsharpMask"
            py.unsharpmaskFunction()
        }
        else if (idComboBoxPresets.currentIndex === 17) {
            currentEffectName = "fxFindEdges"
            py.findedgesFunction()
        }
        else if (idComboBoxPresets.currentIndex === 18) {
            currentEffectName = "fxFindContour"
            py.contourFunction()
        }
        else if (idComboBoxPresets.currentIndex === 19) {
            currentEffectName = "fxEmboss"
            py.embossFunction()
        }
        else if (idComboBoxPresets.currentIndex === 20) {
            currentEffectName = "fxAddFrame"
            py.addFrameFunction()
        }
        else if (idComboBoxPresets.currentIndex === 21) {
            currentEffectName = "fxTintColor"
            py.tintWithColorFunction()
        }
        else if (idComboBoxPresets.currentIndex === 22) {
            currentEffectName = "fxReduceColors"
            py.quantizeFunction()
        }
        else if (idComboBoxPresets.currentIndex === 23) {
            currentEffectName = "fxOpacity"
            py.addAlphaFunction()
        }
        else if (idComboBoxPresets.currentIndex === 24) {
            currentEffectName = "fxAlphaFrom"
            py.colorToAlphaFunction()
        }
        else if (idComboBoxPresets.currentIndex === 25) {
            currentEffectName = "fxExtractColor"
            py.extractColorFunction()
        }
        else if (idComboBoxPresets.currentIndex === 26) {
            currentEffectName = "fxGetChannel"
            py.extractChannelFunction()
        }

        else if (idComboBoxPresets.currentIndex === 27) {
            currentEffectName = "fxMinFilter"
            py.brightspotFilterFunction()
        }
        else if (idComboBoxPresets.currentIndex === 28) {
            currentEffectName = "fxMaxFilter"
            py.brightspotFilterFunction()
        }
        else if (idComboBoxPresets.currentIndex === 29) {
            currentEffectName = "fxMedFilter"
            py.brightspotFilterFunction()
        }
        else if (idComboBoxPresets.currentIndex === 30) {
            currentEffectName = "fxFishEye"
            py.fishEyeFunction()
        }

    }
}
