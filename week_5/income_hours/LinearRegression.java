public class LinearRegression
{
    public static float[] fit(float[] x, float[] y)
    {
        float meanX = calculateMean(x);
        float meanY = calculateMean(y);

        float a = calculateCoefficientA(x, y, meanX, meanY);
        float b = calculateCoefficientB(meanX, meanY, a);

        return new float[]{a, b};
    }

    private static float calculateMean(float[] values)
    {
        float sum = 0;
        for (float value : values) sum += value;
        return sum / values.length;
    }

    private static float calculateCoefficientA(float[] x, float[] y, float meanX, float meanY)
    {
        float numerator = 0;
        float denominator = 0;
        for (int i = 0; i < x.length; ++i)
        {
            numerator += (x[i] - meanX) * (y[i] - meanY);
            denominator += Math.pow((x[i] - meanX), 2);
        }
        return numerator / denominator;
    }

    private static float calculateCoefficientB(float meanX, float meanY, float a)
    {
        return meanY - a * meanX;
    }
}
