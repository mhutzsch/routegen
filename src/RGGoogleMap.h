/*
    Copyright (C) 2008-2011  Michiel Jansen

  This file is part of Route Generator.

    Route Generator is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "ui_googlemap.h"
#include "RGMapBounds.h"

#include <QString>
#include <QPixmap>
#include <QGeoPath>

class RGGoogleMap : public QDialog
{
	Q_OBJECT

public:
    RGGoogleMap(QWidget *parent, const QGeoPath &geoPath = QGeoPath());

	QPixmap getMap() const {return m_map;}
    const RGMapBounds& getMapBounds() const {return m_mapBounds;}

public slots:
    void accept() override;

private slots:
    void on_accept();
    void continue_Accept();
    void on_goButton_clicked(bool);
    void on_fixButton_clicked(bool);
    void on_mapTypeBox_textActivated(const QString &);
    void on_zoomBox_valueChanged(int zoom);

	void on_webView_loadFinished ( bool ok );
	void on_webView_loadProgress ( int progress );
	void on_webView_loadStarted ();

private:
	QString genHtml(const QString &latlon, const QString &zoom) const;

	Ui_googleMap ui;
    QString m_html_template;
    QPixmap m_map;
    QGeoPath m_geoPath;
    RGMapBounds m_mapBounds;
};
