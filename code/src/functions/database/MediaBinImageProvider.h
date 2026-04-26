#ifndef MEDIABINIMAGEPROVIDER_H
#define MEDIABINIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include "MediaBinModel.h"

class MediaBinImageProvider : public QQuickImageProvider
{
public:
    MediaBinImageProvider() : QQuickImageProvider(QQuickImageProvider::Image) {}

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override
    {
        QVariantMap media = MediaBinModel::instance()->getMediaById(id);
        if (media.isEmpty()) return QImage();

        // We need to get the actual item to access the QImage
        // Since getMediaById returns a QVariantMap, we might need a way to get the QImage directly.
        // Let's add a method to MediaBinModel.
        QImage img = MediaBinModel::instance()->getThumbnail(id);
        
        if (size) *size = img.size();
        
        if (requestedSize.width() > 0 && requestedSize.height() > 0) {
            return img.scaled(requestedSize, Qt::KeepAspectRatio);
        }
        
        return img;
    }
};

#endif // MEDIABINIMAGEPROVIDER_H
