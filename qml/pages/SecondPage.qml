import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQml.Models 2.1
import QtGraphicalEffects 1.0;
import org.nemomobile.contacts 1.0
import SortFilterProxyModel 0.2
import "common.js" as ContactsUtils

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    PeopleModel {
        id: peopleModel
        filterType: PeopleModel.FilterAll
        requiredProperty: PeopleModel.NoPropertyRequired
    }

    SortFilterProxyModel {
        id: peopleProxyModel
        sourceModel: peopleModel
        sorters: StringSorter { roleName: "lastName" }
    }


    SilicaListView {
        id: listView
        model: peopleProxyModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Nested Page")
        }
        section {
            property: "lastName"
            criteria: ViewSection.FirstCharacter
            delegate: SectionHeader {
                text: section
            }
        }
        delegate: BackgroundItem {
            id: delegate
            height: Theme.itemSizeSmall

            ListView.onAdd: AddAnimation {
                 target: delegate
            }

            ListView.onRemove: RemoveAnimation {
                target: delegate
            }

            BackgroundItem {
                id: avatar
                x: Theme.horizontalPageMargin
                height: Theme.iconSizeMedium
                width: height

                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: image
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: model.person.filteredAvatarUrl(['local', 'picture', ''])
                    property bool rounded: true
                    property bool adapt: true

                    layer.enabled: rounded
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: avatar.width
                            height: avatar.height
                            Rectangle {
                                anchors.centerIn: parent
                                width: avatar.adapt ? avatar.width : Math.min(avatar.width, avatar.height)
                                height: avatar.adapt ? avatar.height : width
                                radius: Math.min(width, height)
                            }
                        }
                    }
                }
            }

            Item {
                anchors.leftMargin: Theme.paddingLarge
                height: parent.height
                anchors.left: avatar.right
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    id: firstName
                    text: model.firstName
                    color: listView.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeMedium
                }

                Label {
                    text: model.lastName
                    color: listView.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.bold: true
                    anchors.left: firstName.right
                    anchors.leftMargin: Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            onClicked: console.exception(image.status)
        }
        VerticalScrollDecorator {}
    }
}
