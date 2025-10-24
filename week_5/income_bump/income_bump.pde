import processing.svg.*;

import java.util.Arrays;
import java.util.Comparator;

final int nSectors = 4;
final int nIndustries = 19;
final int nBins = 20;
final int incomeMax = 200000;

int[][] cnts = new int[nBins][nSectors];

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

String[] names = {"Primary sector", "Secondary sector", "Tertiary sector", "Quaternary sector"};

color[] palette = new color[nSectors];

int maxCnt;

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
        if (industry < nIndustries)
        {
            ++cnts[getBin(income)][sectors[industry]];
        }
    }
    
    size(2000, 1000);
    
    beginRecord(SVG, "income_bump.svg");
    
    background(0);
    
    final float wLeftBorder = 0.2, wRightBorder = 0.05;
    final float hBorder = 0.05, hHeader = 0.15, hFooter = 0.07;
    final float wSkipAmt = 0.75;
    final float wTotAmt = 1.0 * nBins + wSkipAmt * (nBins - 1);
    final float wSub = 1.0 * (1 - wLeftBorder - wRightBorder) / wTotAmt;
    final float wSkip = wSkipAmt * (1 - wLeftBorder - wRightBorder) / wTotAmt;
    
    translate(0, height * hBorder);
    drawHeader(width, height * hHeader);
    
    translate(width * wLeftBorder, height * hHeader);
    pushMatrix();
    initMax(0, nBins);
    final float hSub = 1 - hBorder * 2 - hHeader - hFooter;
    drawYLabelAndInitPalette(width * wLeftBorder, height * hSub);
    for (int i = 0; i < nBins; ++i)
    {
        drawSubplot(i, width * wSub, height * hSub);
        translate(width * wSub, 0);
        if (i < nBins - 1) drawBump(i, width * wSkip, height * hSub);
        translate(width * wSkip, 0);
    }
    popMatrix();
    
    pushMatrix();
    translate(0, height * (1 - hBorder * 2 - hHeader - hFooter));
    drawXTicks(width * (1 - wLeftBorder - wRightBorder), height * hBorder);
    popMatrix();
    
    pushMatrix();
    initMax(nBins / 2, nBins);
    translate(width * (wSub + wSkip) * (nBins / 2), 0);
    for (int i = nBins / 2; i < nBins; ++i)
    {
        drawSubplot(i, width * wSub, height * ((1 - hBorder * 2 - hHeader - hFooter) / 2));
        translate(width * wSub, 0);
        if (i < nBins - 1) drawBump(i, width * wSkip, height * ((1 - hBorder * 2 - hHeader - hFooter) / 2));
        translate(width * wSkip, 0);
    }
    popMatrix();
    
    noFill();
    stroke(255);
    strokeWeight(width * 0.002);
    beginShape();
    vertex(width * (nBins / 2) * (wSub + wSkip), height * hSub);
    vertex(width * (nBins * (wSub + wSkip) - wSkip), height * hSub);
    vertex(width * (nBins * (wSub + wSkip) - wSkip), height * 0.8 * hSub);
    vertex(width * (nBins / 2) * (wSub + wSkip), height * 0.8 * hSub);
    endShape(CLOSE);
    beginShape();
    vertex(width * (nBins / 2) * (wSub + wSkip), 0);
    vertex(width * (nBins * (wSub + wSkip) - wSkip), 0);
    vertex(width * (nBins * (wSub + wSkip) - wSkip), height * 0.5 * hSub);
    vertex(width * (nBins / 2) * (wSub + wSkip), height * 0.5 * hSub);
    endShape(CLOSE);
    beginShape(LINES);
    vertex(width * (nBins / 2 + 1) * (wSub + wSkip), height * 0.8 * hSub);
    vertex(width * (nBins / 2) * (wSub + wSkip), height * 0.5 * hSub);
    vertex(width * ((nBins - 1) * (wSub + wSkip) - wSkip), height * 0.8 * hSub);
    vertex(width * (nBins * (wSub + wSkip) - wSkip), height * 0.5 * hSub);
    endShape();
    
    translate(0, height * (hSub + hBorder));
    drawFooter(width * (nBins * (wSub + wSkip) - wSkip), height * hFooter);
    
    endRecord();
}

Integer[] getSorted(int i)
{
    Integer[] ids = new Integer[nSectors];
    for (int j = 0; j < nSectors; ++j) ids[j] = j;
    Arrays.sort(ids, Comparator.comparingInt(id -> cnts[i][id]));
    return ids;
}

void initMax(int l, int r)
{
    maxCnt = 0;
    for (int i = l; i < r; ++i)
    {
        int sum = 0;
        for (int c : cnts[i]) sum += c;
        maxCnt = max(maxCnt, sum);
    }
}

void drawYLabelAndInitPalette(float w, float h)
{
    color[] colors = {#1D7883, #2FA17F, #89C464, #F6D954};
    Integer[] ids = getSorted(0);
    for (int j = 0; j < nSectors; ++j) palette[ids[j]] = colors[j];
    
    pushMatrix();
    translate(-w / 12, 0);
    
    final int yStep = 200;
    for (int i = 0; i <= maxCnt + yStep - 1; i += yStep)
    {
        fill(255);
        textSize(16);
        textAlign(RIGHT, CENTER);
        
        text(Integer.toString(i), 0, h * (1 - 1.0 * i / maxCnt));
    }
    fill(255);
    textSize(20);
    textAlign(RIGHT, CENTER);
    text("No. of workers", 0, -h / 10);
    
    popMatrix();
    
    pushMatrix();
    translate(-w / 4, h);
    
    for (int j : ids)
    {
        fill(palette[j]);
        textSize(32);
        textAlign(RIGHT, CENTER);
        float hBar = h * cnts[0][j] / maxCnt;
        translate(0, -hBar / 2);
        text(names[j], 0, 0);
        translate(0, -hBar / 2);
    }
    
    popMatrix();
}

void drawHeader(float w, float h)
{
    fill(255);
    textSize(h / 2.2);
    textAlign(CENTER, TOP);
    text("Number of Workers by Income and Sector", w / 2, 0);
}

void drawSubplot(int i, float w, float h)
{
    pushMatrix();
    translate(0, h);
    
    Integer[] ids = getSorted(i);
    
    for (int j : ids)
    {
        fill(palette[j]);
        stroke(palette[j]);
        strokeWeight(2);
        //noStroke();
        float hBar = h * cnts[i][j] / maxCnt;
        rect(0, 0, w, -hBar);
        translate(0, -hBar);
    }
    
    popMatrix();
}

void drawBump(int i, float w, float h)
{
    pushMatrix();
    translate(0, h);
    
    Integer[] ids = getSorted(i);
    Integer[] idsNxt = getSorted(i + 1);
    
    float[] hBarNxt = new float[nSectors];
    float[] dhBarNxt = new float[nSectors];
    for (int j = 0; j < nSectors; ++j)
    {
        dhBarNxt[idsNxt[j]] = h * cnts[i + 1][idsNxt[j]] / maxCnt;
        if (j > 0) hBarNxt[idsNxt[j]] = hBarNxt[idsNxt[j - 1]] + dhBarNxt[idsNxt[j - 1]];
    }
    
    float hBar = 0;
    for (int j = 0; j < nSectors; ++j)
    {
        fill(palette[ids[j]]);
        noStroke();
        float dh = h * cnts[i][ids[j]] / maxCnt;
        //quad(0, -hBar, 0, -(hBar + dh), w, -(hBarNxt[ids[j]] + dhBarNxt[ids[j]]), w, -hBarNxt[ids[j]]);
        
        float mid0 = ((hBar + dh) + (hBarNxt[ids[j]] + dhBarNxt[ids[j]])) / 2;
        float mid1 = (hBarNxt[ids[j]] + hBar) / 2;
        float center = (mid0 + mid1) / 2;
        
        beginShape();
        vertex(0, -(hBar + dh));
        quadraticVertex(w / 2, -(mid0 + center) / 2, w, -(hBarNxt[ids[j]] + dhBarNxt[ids[j]]));
        vertex(w, -hBarNxt[ids[j]]);
        quadraticVertex(w / 2, -(mid1 + center) / 2, 0, -hBar);
        endShape();
        hBar += dh;
    }
    popMatrix();
}

void drawXTicks(float w, float h)
{   
    final int nTicks = 10;
    
    pushMatrix();
    translate(0, h / 4);
    for (int i = 0; i <= nTicks; ++i)
    {
        fill(255);
        textSize(16);
        textAlign(CENTER, TOP);
        
        if (i < nTicks)
        {
            text(Integer.toString(incomeMax / nTicks * i), w * i / nTicks, 0);
        }
        else
        {
            text("≥" + Integer.toString(incomeMax / nBins * (nBins - 1)), w * (nBins - 1) / nBins, 0);
        }
    }
    popMatrix();
}

void drawFooter(float w, float h)
{
    fill(255);
    textSize(20);
    textAlign(CENTER, TOP);
    text("Yearly income in CNY from 2018 CFPS survey", w / 2, 0);
}

void draw()
{
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}
