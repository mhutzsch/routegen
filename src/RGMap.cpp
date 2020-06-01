#include "RGMap.h"
#include "RGSettings.h"

#include <QJsonObject>

RGMap::RGMap(QObject *parent)
    :QObject(parent),
     mDirty(false)
{

}

bool RGMap::loadMap(const QString &fileName, const QPixmap &map, const QRectF mapBounds)
{
    bool success = !map.isNull();
    mFileName = fileName;
    if (map.isNull())
    {
        success = mMap.load(fileName);
    }
    else
    {
        mMap = map;
    }

    if (success)
    {
        //Store or retrieve map's geo boundaries
        if (mapBounds.isValid())
        {
            mGeoBounds = mapBounds;
            RGSettings::setMapGeoBounds(fileName, mapBounds);
        }
        else
        {
            mGeoBounds = RGSettings::getMapGeoBounds(fileName);
        }

        emit mapLoaded(mMap);
    }

    mDirty = true;

    return success;
}

bool RGMap::hasGeoBounds() const
{
    return mGeoBounds.isValid();
}

QRectF RGMap::geoBounds() const
{
    return mGeoBounds;
}

QList<QPoint> RGMap::mapRoutePoints(const QList<QGeoCoordinate> &geoCoordinates) const
{
    QList<QPoint> pointlist;
    if (mGeoBounds.isValid())
    {
        double xScale = mMap.width() / mGeoBounds.width();
        double yScale = mMap.height() / mGeoBounds.height();

        for (const QGeoCoordinate &coord: geoCoordinates)
        {
            //Make the long range from -180.0/180.0 to 0.0/360.0 to scale it on the map
            double longitude = coord.longitude();
            if (longitude < 0.0)
            {
                longitude = 180.0 + (180.0 + longitude);
            }
            QPoint point((coord.longitude() - mGeoBounds.x()) * xScale,
                         (mGeoBounds.y() - coord.latitude()) * yScale);
            pointlist.append(point);
        }
    }
    return pointlist;
}

QString RGMap::fileName() const
{
    return mFileName;
}

bool RGMap::isEmpty() const
{
    return mMap.isNull();
}

bool RGMap::isDirty() const
{
    return mDirty;
}

void RGMap::resetDirty()
{
    mDirty = false;
}

void RGMap::clearMap()
{
    mMap = QPixmap();
    mGeoBounds = QRectF();
    resetDirty();
    emit mapLoaded(mMap);
}

void RGMap::read(const QJsonObject &json)
{
    QJsonValue mapValue = json.value(QStringLiteral("map"));
    if (mapValue.isObject())
    {
        QJsonObject mapObject = mapValue.toObject();
        QString fileName = mapObject.value(QStringLiteral("fileName")).toString();
        if (!fileName.isEmpty())
        {
            loadMap(fileName);
        }
    }
}

void RGMap::write(QJsonObject &json)
{
    QJsonObject mapObject;
    mapObject.insert(QStringLiteral("fileName"), mFileName);

    //The geobounds are stored along with the map in the settings, so no meed to store them in the project

    json.insert(QStringLiteral("map"), mapObject);
}
