TARGET = moe.smoothie.imageworks

CONFIG += auroraapp

SOURCES += src/moe.smoothie.imageworks.cpp \

DISTFILES += qml/moe.smoothie.imageworks.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ChannelBench.qml \
    qml/pages/CollageBench.qml \
    qml/pages/ColorcurveBench.qml \
    qml/pages/EffectsBench.qml \
    qml/pages/FilterBench.qml \
    qml/pages/FirstPage.qml \
    qml/pages/InfoPage.qml \
    qml/pages/MetadataPage.qml \
    qml/pages/NewPage.qml \
    qml/pages/PixelBench.qml \
    qml/pages/RenamePage.qml \
    qml/pages/SavePage.qml \
    qml/pages/ViewPage.qml \
    qml/pages/perspectivetransformhelper.js \
    rpm/moe.smoothie.imageworks.spec \
    translations/*.ts \
    moe.smoothie.imageworks.desktop \
    rpm/moe.smoothie.imageworks.changes

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/moe.smoothie.imageworks-*.ts

HEADERS +=
