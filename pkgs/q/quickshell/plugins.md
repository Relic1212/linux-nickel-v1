
there will be things like this:
 ERROR:   caused by @Common/I18n.qml[4:1]: module "Qt.labs.folderlistmodel" is not installed

then you look for a plugin called somethinf with folderlistmodel. You will find:
QmlFolderListModelPlugin

it is defined in libqmlfolderlistmodelplugin.a

then go

rg libqmlfolderlistmodelplugin $SYSROOT/lib

look at the name of the defined target and link it

note:
Q_IMPORT_PLUGIN and Q_IMPORT_QML_PLUGIN doesn't really matter as long as Q_IMPORT_QML_PLUGIN is used once.