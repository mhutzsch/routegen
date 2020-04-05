#ifndef RGGPXREADER_H
#define RGGPXREADER_H

#include "RGReader.h"

class QProgressDialog;
class QStringList;
class QXmlStreamReader;

class RGGPXReader : public RGReader
{
public:
    RGGPXReader(RGRoute *route, RGMap *map, QWidget *parent = nullptr);

    bool readFile(const QString &fileName) override;

private:
    bool collectNames(QXmlStreamReader &inputStream, QProgressDialog &pd, QStringList &routeNames, QStringList &trackNames);
};

#endif // RGGPXREADER_H
