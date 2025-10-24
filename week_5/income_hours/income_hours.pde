float[] income;
float[] hours;
int nRows;
float minIncome, maxIncome;
float minHours, maxHours;

void setup()
{
    Table table = loadTable("../data/waged.csv", "header");
    nRows = table.getRowCount();
    income = new float[nRows];
    hours = new float[nRows];
    
    for (int i = 0; i < nRows; ++i)
    {
        var row = table.getRow(i);
        income[i] = row.getFloat("income");
        hours[i] = row.getFloat("hours");
    }
    
    minIncome = maxIncome = income[0];
    for (float i : income)
    {
        minIncome = min(minIncome, i);
        maxIncome = max(maxIncome, i);
    }
    minHours = maxHours = hours[0];
    for (float i : hours)
    {
        minHours = min(minHours, i);
        maxHours = max(maxHours, i);
    }
    
    size(1800, 1200);
}

void drawHeader(float w, float h)
{
    fill(255);
    textSize(h / 3);
    textAlign(CENTER, CENTER);
    text("Working Hours vs. Income", w / 2, h / 2);
}

void drawYTicks(float w, float h)
{
    final int step = 25;
    for (int i = 0; i <= maxHours + step - 1; i += step)
    {
        fill(255);
        textSize(32);
        textAlign(RIGHT, CENTER);
        text(Integer.toString(i), -w / 4, h * map(i, minHours, maxHours, 1, 0));
    }
    
    fill(255);
    textSize(32);
    textAlign(RIGHT, CENTER);
    text("Weekly\nworking\nhours", -w / 2, h / 2);
}

void drawXTicks(float w, float h)
{
    final int step = 50000;
    for (int i = 0; i <= maxIncome + step - 1; i += step)
    {
        fill(255);
        textSize(32);
        textAlign(CENTER, TOP);
        text(Integer.toString(i), w * map(i, minIncome, maxIncome, 0, 1), h / 4);
    }
    
    fill(255);
    textSize(32);
    textAlign(CENTER, TOP);
    text("Yearly income in CNY from 2018 CFPS survey", w / 2, h / 2);
}

void drawScatter(float w, float h)
{
    for (int i = 0; i < nRows; ++i)
    {
        noStroke();
        fill(255, 255, 255, 255 / 5);
        float x = map(income[i], minIncome, maxIncome, 0, w);
        float y = map(hours[i], minHours, maxHours, h, 0);
        circle(x, y, w / 100);
    }
}

void drawLine(float w, float h)
{
    float[] line = LinearRegression.fit(income, hours);
    float y0 = map(line[0] * minIncome + line[1], minHours, maxHours, h, 0);
    float y1 = map(line[0] * maxIncome + line[1], minHours, maxHours, h, 0);
    strokeWeight(w / 100);
    stroke(255, 0, 0);
    line(0, y0, w, y1);
}

void draw()
{
    background(0);
    final float wLeft = 0.18, wRight = 0.1;
    final float hHeader = 0.2, hFooter = 0.22;
    drawHeader(width, height * hHeader);
    translate(width * wLeft, height * hHeader);
    drawYTicks(width * wLeft, height * (1 - hHeader - hFooter));
    drawScatter(width * (1 - wLeft - wRight), height * (1 - hHeader - hFooter));
    drawLine(width * (1 - wLeft - wRight), height * (1 - hHeader - hFooter));
    translate(0, height * (1 - hHeader - hFooter));
    drawXTicks(width * (1 - wLeft - wRight), height * hFooter);
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}
