#include "normal_random.h"
#include <iostream>

NormalRandom::NormalRandom(QObject *parent)
    : QObject(parent)
    , m_rdgen(m_rddev())
{}

bool NormalRandom::pickCorrectCard(double distributionSize)
{
    std::normal_distribution<> distributor { 0, 2 * distributionSize };
    return 0 == std::round(distributor(m_rdgen));
}