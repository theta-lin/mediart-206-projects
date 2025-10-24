import processing.svg.*;

import java.util.Arrays;
import java.util.Comparator;

final int nIndustries = 20;
final int nBins = 16;
final int incomeMax = 160000;

int[][]   bins  = new int[nIndustries][nBins];
int[]     cnts  = new int[nIndustries];
float[]   means = new float[nIndustries];
Integer[] ids   = new Integer[nIndustries];
String[]  names = {"Agriculture", "Mining", "Manufacturing", "Energy", "Construction",
                   "Transportation", "IT", "Retail", "Hotel and catering", "Finance",
                   "Real estate", "Commercial service", "Technical service", "Resource management", "Residential service",
                   "Education", "Public service", "Recreation", "Social organization", "Other industries"};
color[]   palette = {#FADD5F,#DCDE61,#BEDD69,#A0DA75,#84D683,
                     #69D192,#52CBA0,#40C4AD,#3ABBB7,#43B2BE,
                     #54A8C0,#679DBF,#7A91B9,#8986B0,#967AA3,
                     #9F6F94,#A36584,#A45C72,#A15561,#9B5051};
int[] sectors = {
    0, // Agriculture -> Primary
    0, // Mining -> Primary
    1, // Manufacturing -> Secondary
    1, // Energy -> Secondary
    1, // Construction -> Secondary
    2, // Transportation -> Tertiary
    3, // IT -> Quaternary
    2, // Retail -> Tertiary
    2, // Hotel and catering -> Tertiary
    3, // Finance -> Quaternary
    3, // Real estate -> Quaternary
    2, // Commercial service -> Tertiary
    3, // Technical service -> Quaternary
    2, // Resource management -> Tertiary
    2, // Residential service -> Tertiary
    3, // Education -> Quaternary
    2, // Public service -> Tertiary
    3, // Recreation -> Quaternary
    2  // Social organization -> Tertiary
};
color[] colorSectors = {#1D7883, #89C464, #F6D954, #2FA17F};

int getBin(int n)
{
    int binSize = incomeMax / nBins;
    return min(n / binSize, nBins - 1);
}

void setup()
{
    Table table = loadTable("../data/waged.csv", "header");
    
    for (var row : table.rows())
    {
        int industry = row.getInt("industry") - 1;
        int income = row.getInt("income");
        ++bins[industry][getBin(income)];
        ++cnts[industry];
        means[industry] += income;
    }
    
    for (int i = 0; i < nIndustries; ++i) means[i] /= cnts[i];
    for (int i = 0; i < nIndustries; ++i) ids[i] = i;
    Arrays.sort(ids, Comparator.comparingDouble(id -> means[id]));
    
    size(1000, 2000);
    
    beginRecord(SVG, "income_hist.svg");
    
    final float wBorder = 0.28, hBorder = 0.03, hHeader = 0.07, hFooter = 0.07;
    final float hSkipAmt = 0.0;
    final float hTotAmt = 1.0 * nIndustries + hSkipAmt * (nIndustries - 1);
    final float hSub = 1.0 * (1 - hBorder * 2 - hHeader - hFooter) / hTotAmt;
    final float hSkip = hSkipAmt * (1 - hBorder * 2 - hHeader - hFooter) / hTotAmt;
    final float textSkip = 0.018;
    final float swAmt1 = 0.002, swAmt2 = 0.02;
    
    background(0);
    
    pushMatrix();
    translate(0, height * hBorder);
    drawHeader(width, height * hHeader);
    
    translate(width * wBorder, height * hHeader);
    pushMatrix();
    for (int i = 0; i < nIndustries; ++i)
    {
        drawSubplot(ids[i], width * (1 - wBorder * 2), height * hSub, palette[i]);
        if (i == nIndustries / 2) drawYAnno(width * (1 - wBorder * 2), height * hSub, width * swAmt1);
        translate(0, height * (hSub + hSkip));
    }
    popMatrix();
    
    
    translate(0, -height * textSkip);
    drawXTicks(width * (1 - wBorder * 2), height * (1 - hBorder * 2 - hHeader - hFooter + textSkip * 2), width * swAmt2);
    popMatrix();
    
    translate(0, height * (1 - hBorder - hFooter));
    drawFooter(width, height * hFooter);
    
    endRecord();
}

void drawHeader(float w, float h)
{
    fill(255);
    textSize(h / 2);
    textAlign(CENTER, TOP);
    text("Income Distribution by Industry", w / 2, 0);
}

void drawSubplot(int i, float w, float h, color c)
{   
    strokeWeight(2);
    if (i == 19)
    {
        fill(255);
        stroke(255);
    }
    else
    {
        fill(colorSectors[sectors[i]]);
        stroke(colorSectors[sectors[i]]);
    }
    textSize(24);
    textAlign(RIGHT, BOTTOM);
    text(names[i], -20, h);

    int sum = 0;
    for (int n : bins[i]) sum += n;
    
    final float maxAmt = 0.3;
    //fill(c);
    //noStroke();
    w /= nBins;
    for (int j = 0; j < nBins; ++j)
    {
        float hCur = 1.0 * bins[i][j] / sum / maxAmt * h;
        rect(w * j, h - hCur, w, hCur);
    }
}

void drawXTicks(float w, float h, float sw)
{
    strokeWeight(sw);
    stroke(0);
    fill(255);
    textSize(16);
    textAlign(CENTER, TOP);
    
    final int nTicks = 4;
    for (int i = 0; i <= nTicks; ++i)
    {
        if (i > 0 && i < nTicks) line(w * i / nTicks, 0, w * i / nTicks, h);
        
        if (i < nTicks)
        {
            text(Integer.toString(incomeMax / nTicks * i), w * i / nTicks, 0);
            text(Integer.toString(incomeMax / nTicks * i), w * i / nTicks, h);
        }
        else
        {
            text("≥" + Integer.toString(incomeMax / nBins * (nBins - 1)), w * i / nTicks, 0);
            text("≥" + Integer.toString(incomeMax / nBins * (nBins - 1)), w * i / nTicks, h);
        }
    }
}

void drawYAnno(float w, float h, float sw)
{
    strokeWeight(sw);
    stroke(255);
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    
    line(w * 1.05, 0, w * 1.1, 0);
    line(w * 1.05, h, w * 1.1, h);
    line(w * 1.1, 0, w * 1.1, h);
    text("30% of the workers\nin the industry", w * 1.12, h / 2);
}

void drawFooter(float w, float h)
{
    fill(255);
    textSize(20);
    text("Yearly income in CNY from 2018 CFPS survey", w / 2, h / 1.6);
    text("The industries are sorted ascending by mean income", w / 2, h / 1.6 + h / 5);
    text("Each bar in the histogram represents a percentage of the workers within that particular industry", w / 2, h / 1.6 + 2 * h / 5);
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}
