#ifndef FRAMEVIEW_H
#define FRAMEVIEW_H

#include <QQuickPaintedItem>
#include <QImage>

class FrameView : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QImage frame READ frame WRITE setFrame NOTIFY frameChanged)

public:
    explicit FrameView(QQuickItem *parent = nullptr);

    QImage frame() const;
    void setFrame(const QImage &frame);

    void paint(QPainter *painter) override;

signals:
    void frameChanged();

private:
    QImage m_frame;
};

#endif
