#include <QObject>
#include <random>

class NormalRandom : public QObject
{
    Q_OBJECT

public:
    NormalRandom(QObject *parent = nullptr);
    ~NormalRandom() = default;

public slots:
    bool pickCorrectCard(double distributionSize);

private:
    std::random_device m_rddev;
    std::mt19937       m_rdgen;
};