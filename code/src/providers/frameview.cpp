#include "frameview.h"
#include <QPainter>

FrameView::FrameView(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

QImage FrameView::frame() const
{
    return m_frame;
}

void FrameView::setFrame(const QImage &frame)
{
    if (m_frame == frame)
        return;
    m_frame = frame;
    emit frameChanged();
    update();
}

void FrameView::paint(QPainter *painter)
{
    if (m_frame.isNull()) {
        painter->fillRect(boundingRect().toRect(), Qt::black);
        return;
    }

    QRectF targetRect = boundingRect();
    QRectF sourceRect(0, 0, m_frame.width(), m_frame.height());

    double targetAspect = targetRect.width() / targetRect.height();
    double sourceAspect = sourceRect.width() / sourceRect.height();

    QRectF drawRect;
    if (targetAspect > sourceAspect) {
        drawRect.setHeight(targetRect.height());
        drawRect.setWidth(targetRect.height() * sourceAspect);
    } else {
        drawRect.setWidth(targetRect.width());
        drawRect.setHeight(targetRect.width() / sourceAspect);
    }
    drawRect.moveCenter(targetRect.center());

    painter->fillRect(boundingRect().toRect(), Qt::black);
    painter->setRenderHint(QPainter::SmoothPixmapTransform);
    painter->drawImage(drawRect, m_frame, sourceRect);
}
