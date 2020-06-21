#include "RGMap.h"
#include "RGSettings.h"

#include <QJsonObject>
#include <QtMath>

#include <algorithm>

namespace
{
    int TILE_SIZE = 256;
}

RGMap::RGMap(QObject *parent)
    :QObject(parent),
     mDirty(false)
{

}

bool RGMap::loadMap(const QString &fileName, const QPixmap &map, const RGMapBounds &mapBounds)
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
            m_bounds = mapBounds;
            //TODO:RGSettings::setMapGeoBounds(fileName, mapBounds);
        }
        else
        {
            //TODO:mGeoBounds = RGSettings::getMapGeoBounds(fileName);
        }

        //Calculate topleft/bottomright of the current map in pixel coordinates
        mTopLeft = worldToPixel(project(QGeoCoordinate(m_bounds.getNE().latitude(), m_bounds.getSW().longitude())));
        mBottomRight = worldToPixel(project(QGeoCoordinate(m_bounds.getSW().latitude(), m_bounds.getNE().longitude())));

        emit mapLoaded(mMap);
    }

    mDirty = true;

    return success;
}

bool RGMap::hasGeoBounds() const
{
    return m_bounds.isValid();
}

RGMapBounds RGMap::geoBounds() const
{
    return m_bounds;
}

QList<QPoint> RGMap::mapRoutePoints(const QList<QGeoCoordinate> &geoCoordinates) const
{
    QList<QPoint> pointlist;
    if (m_bounds.isValid())
    {
        for (const QGeoCoordinate &coord: geoCoordinates)
        {
            //TODO: convert to google projection algorithm
            /*
            QPoint point((coord.longitude() - mGeoBounds.x()) * xScale,
                         (mGeoBounds.y() - coord.latitude()) * yScale);
            pointlist.append(point);
            */
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
    m_bounds = RGMapBounds();
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

QPointF RGMap::project(const QGeoCoordinate &geoPoint)
{
    qreal siny = qSin(geoPoint.latitude() * M_PI / 180);

    // Algorithm copied from Google maps API
    // Truncating to 0.9999 effectively limits latitude to 89.189. This is
    // about a third of a tile past the edge of the world tile.
    siny = std::min(std::max(siny, -0.9999), 0.9999);

    return QPointF(
        TILE_SIZE * (0.5 + geoPoint.longitude() / 360),
        TILE_SIZE * (0.5 - std::log((1 + siny) / (1 - siny)) / (4 * M_PI)));
}

QPoint RGMap::worldToPixel(const QPointF &worldPoint)
{
    int scale = 1 << m_bounds.getZoom();
    return QPoint(
         qFloor(worldPoint.x() * scale),
         qFloor(worldPoint.y() * scale));
}
