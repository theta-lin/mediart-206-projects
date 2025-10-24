import processing.svg.*;
import processing.pdf.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;

final float noiseScale = 0.01; // Scale of the noise xy-coordinates
//final float noiseScale = 0.006; // Scale of the noise xy-coordinates

PVector getGrad(float x, float y, float z)
{
    x = abs(x - width / 2);
    y = abs(y - width / 2);
    
    final float eps = 1;
    float h = noise(x * noiseScale, y * noiseScale, z);
    float hx = noise(x * noiseScale + eps, y * noiseScale, z);
    float hy = noise(x * noiseScale, y * noiseScale + eps, z);
    var d = new PVector(hx - h, hy - h);
    d.normalize();
    return d;
}

HashMap<Character, ArrayList<ArrayList<Integer>>> strokes = new HashMap<>();

void buildAlphabet()
{
    strokes.put('A', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(20, 2, 24)),
        new ArrayList<>(Arrays.asList(11, 13))
    )));
    strokes.put('B', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 3, 9, 13, 10, 13, 19, 23, 20))
    )));
    strokes.put('C', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(9, 3, 1, 5, 15, 21, 23, 19))
    )));
    strokes.put('D', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 3, 9, 19, 23, 20))
    )));
    strokes.put('E', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 4)),
        new ArrayList<>(Arrays.asList(10, 14)),
        new ArrayList<>(Arrays.asList(20, 24))
    )));
    strokes.put('F', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 4)),
        new ArrayList<>(Arrays.asList(10, 14))
    )));
    strokes.put('G', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(9, 3, 1, 5, 15, 21, 23, 19, 14, 12))
    )));
    strokes.put('H', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(10, 14)),
        new ArrayList<>(Arrays.asList(4, 24))
    )));
    strokes.put('I', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(1, 3)),
        new ArrayList<>(Arrays.asList(2, 22)),
        new ArrayList<>(Arrays.asList(21, 23))
    )));
    strokes.put('J', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(1, 3, 18, 22, 16))
    )));
    strokes.put('K', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(4, 10, 24))
    )));
    strokes.put('L', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20, 24))
    )));
    strokes.put('M', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(20, 0, 17, 4, 24))
    )));
    strokes.put('N', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(20, 0, 24, 4))
    )));
    strokes.put('O', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(1, 3, 9, 19, 23, 21, 15, 5, 1))
    )));
    strokes.put('P', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 3, 9, 13, 10))
    )));
    strokes.put('Q', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(1, 3, 9, 19, 23, 21, 15, 5, 1)),
        new ArrayList<>(Arrays.asList(12, 24))
    )));
    strokes.put('R', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 20)),
        new ArrayList<>(Arrays.asList(0, 3, 9, 13, 10, 24))
    )));
    strokes.put('S', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(4, 1, 5, 11, 13, 19, 23, 20))
    )));
    strokes.put('T', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 4)),
        new ArrayList<>(Arrays.asList(2, 22))
    )));
    strokes.put('U', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 15, 21, 23, 19, 4))
    )));
    strokes.put('V', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 22, 4))
    )));
    strokes.put('W', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 21, 7, 23, 4))
    )));
    strokes.put('X', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 24)),
        new ArrayList<>(Arrays.asList(4, 20))
    )));
    strokes.put('Y', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 12)),
        new ArrayList<>(Arrays.asList(4, 12, 22))
    )));
    strokes.put('Z', new ArrayList<>(Arrays.asList(
        new ArrayList<>(Arrays.asList(0, 4, 20, 24))
    )));
}

float getCharLen(char c)
{
    float sum = 0;
    
    var charStrokes = strokes.get(c);
    for (var s : charStrokes)
    {
        for (int i = 0; i + 1 < s.size(); i += 1)
        {
            float x0 = s.get(i) % 5, y0 = s.get(i) / 5;
            float x1 = s.get(i + 1) % 5, y1 = s.get(i + 1) / 5;
            sum += sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
        }
    }
    
    return sum;
}

float getStrokeLen(ArrayList<Integer> s)
{
    float sum = 0;
    
    for (int i = 0; i + 1 < s.size(); i += 1)
    {
        float x0 = s.get(i) % 5, y0 = s.get(i) / 5;
        float x1 = s.get(i + 1) % 5, y1 = s.get(i + 1) / 5;
        sum += sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
    }
    
    return sum;
}

public class StrokeSeg
{
    public ArrayList<Integer> s;
    public int i;
    public float sum;
    public float cur;
    public float sumStroke;
    
    public StrokeSeg(ArrayList<Integer> s, int i, float sum, float cur, float sumStroke)
    {
        this.s = s;
        this.i = i;
        this.sum = sum;
        this.cur = cur;
        this.sumStroke = sumStroke;
    }
}

StrokeSeg getSeg(char c, float len)
{
    float sum = 0;
    float sumStroke = 0;
    
    var charStrokes = strokes.get(c);
    for (var s : charStrokes)
    {
        float sumCurStroke = 0;
        for (int i = 0; i + 1 < s.size(); i += 1)
        {
            float x0 = s.get(i) % 5, y0 = s.get(i) / 5;
            float x1 = s.get(i + 1) % 5, y1 = s.get(i + 1) / 5;
            float cur = sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
            if (len <= sum + cur) return new StrokeSeg(s, i, sum, cur, sumStroke);
            sum += cur;
            sumCurStroke += cur;
        }
        sumStroke += sumCurStroke;
    }
    
    return null;
}

public interface Agent
{
    ArrayList<Agent> update();
}

public class Trunk implements Agent
{
    ///*
    private static final int   tMax = 300;                             // Maximum time (in frames)
    private static final float swBeg = 15, swMid = 25;                 // Stroke weight at beginning and middle
    private static final float swExp = 1.5;                            // Stroke weight interpolation exponent
    private static final float smoothAmt = 0.2;                        // Bezier curve amount at corners
    private static final float dispScale = 5;                          // Amount of displacement along noise gradient
    private static final float branchProb = 0.15;                      // Probability of creating a new branch
    private static final float branchScale = 1;                        // Scale of the branch initial stroke weight
    private static final float branchLenMin = 150, branchLenMax = 300; // Minimum and maximum branch length
    //*/
    
    /*
    private static final int   tMax = 300;                             // Maximum time (in frames)
    private static final float swBeg = 30, swMid = 50;                 // Stroke weight at beginning and middle
    private static final float swExp = 1.5;                            // Stroke weight interpolation exponent
    private static final float smoothAmt = 0.2;                        // Bezier curve amount at corners
    private static final float dispScale = 5;                          // Amount of displacement along noise gradient
    private static final float branchProb = 0.17;                      // Probability of creating a new branch
    private static final float branchScale = 1;                        // Scale of the branch initial stroke weight
    private static final float branchLenMin = 300, branchLenMax = 600; // Minimum and maximum branch length
    //*/
    
    private final char c;
    private final float xScale, yScale;
    private final float xOrigin, yOrigin;
    private int t = 0;
    
    public Trunk(char c, float xScale, float yScale, float xOrigin, float yOrigin)
    {
        this.c = c;
        this.xScale = xScale;
        this.yScale = yScale;
        this.xOrigin = xOrigin;
        this.yOrigin = yOrigin;
    }
    
    ArrayList<Agent> update()
    {
        ArrayList<Agent> reps = new ArrayList<>(Arrays.asList(this));
        if (t >= tMax) return reps;
        
        float amtTot = 1.0 * t / tMax;
        float totLen = getCharLen(c);
        var seg = getSeg(c, amtTot * totLen);
        var s = seg.s;
        var i = seg.i;
        float amt = map(amtTot, seg.sum / totLen, (seg.cur + seg.sum) / totLen, 0, 1);
        float amtStroke = map(amtTot, seg.sumStroke / totLen, (seg.sumStroke + getStrokeLen(s)) / totLen, 0, 1);
        
        float x0 = s.get(i) % 5, y0 = s.get(i) / 5;
        float x1 = s.get(i + 1) % 5, y1 = s.get(i + 1) / 5;

        float x, y;
        if (i > 0 && amt < smoothAmt)
        {
            float xp = s.get(i - 1) % 5, yp = s.get(i - 1) / 5;
            float xBeg = lerp(xp, x0, 1 - smoothAmt), yBeg = lerp(yp, y0, 1 - smoothAmt);
            float xEnd = lerp(x0, x1, smoothAmt), yEnd = lerp(y0, y1, smoothAmt);
            float amtCurve = map(amt, 0, smoothAmt, 0.5, 1);
            
            x = lerp(lerp(xBeg, x0, amtCurve), lerp(x0, xEnd, amtCurve), amtCurve);
            y = lerp(lerp(yBeg, y0, amtCurve), lerp(y0, yEnd, amtCurve), amtCurve);
        }
        else if (i + 2 < s.size() && amt >= 1 - smoothAmt)
        {
            float x2 = s.get(i + 2) % 5, y2 = s.get(i + 2) / 5;
            float xBeg = lerp(x0, x1, 1 - smoothAmt), yBeg = lerp(y0, y1, 1 - smoothAmt);
            float xEnd = lerp(x1, x2, smoothAmt), yEnd = lerp(y1, y2, smoothAmt);
            float amtCurve = map(amt, 1 - smoothAmt, 1, 0, 0.5);
            
            x = lerp(lerp(xBeg, x1, amtCurve), lerp(x1, xEnd, amtCurve), amtCurve);
            y = lerp(lerp(yBeg, y1, amtCurve), lerp(y1, yEnd, amtCurve), amtCurve);
        }
        else
        {
            x = lerp(x0, x1, amt);
            y = lerp(y0, y1, amt);
        }
        
        x = xOrigin + x * xScale;
        y = yOrigin + y * yScale;
        
        var d = getGrad(x, y, 0);
        x += d.x * dispScale;
        y += d.y * dispScale;
        
        float sw = lerp(swMid, swBeg, pow(abs(amtStroke - 0.5) * 2, swExp));
        
        stroke(255);
        strokeWeight(sw);
        point(x, y);
        
        if (random(1) < branchProb)
        {
            reps.add(new Branch(x, y, random(branchLenMin, branchLenMax), branchScale * sw, 0, 0));
        }
        
        ++t;
        return reps;
    }
}

public class Branch implements Agent
{
    ///*
    private static final int   tMax = 200;                            // Maximum time (in frames)
    private static final float swExp = 0.75;                          // Stroke weight interpolation exponent
    private static final float randAmt = 0.55;                        // Amount of random gradient added to branch movement
    private static final float yShiftMax = 5;                         // Maximum downward shift
    private static final float yShiftExp = 3;                         // Downward shift interpolation exponent
    private static final int   depthMax = 1;                          // Maximum branch depth
    private static final float branchProb = 0.05;                     // Probability of creating a new branch
    private static final float branchScale = 0.8;                     // Scale of the branch initial stroke weight
    private static final float branchLenMin = 50, branchLenMax = 100; // Minimum and maximum branch length
    //*/
    
    /*
    private static final int   tMax = 200;                            // Maximum time (in frames)
    private static final float swExp = 0.75;                          // Stroke weight interpolation exponent
    private static final float randAmt = 0.55;                        // Amount of random gradient added to branch movement
    private static final float yShiftMax = 10;                         // Maximum downward shift
    private static final float yShiftExp = 5;                         // Downward shift interpolation exponent
    private static final int   depthMax = 1;                          // Maximum branch depth
    private static final float branchProb = 0.06;                     // Probability of creating a new branch
    private static final float branchScale = 0.8;                     // Scale of the branch initial stroke weight
    private static final float branchLenMin = 100, branchLenMax = 200; // Minimum and maximum branch length
    //*/
    
    private float x, y;
    private final float len;
    private final float sw;
    private final int depth;
    private int t;
    
    public Branch(float x, float y, float len, float sw, int t, int depth)
    {
        this.x = x;
        this.y = y;
        this.len = len;
        this.sw = sw;
        this.t = t;
        this.depth = depth;
    }
    
    ArrayList<Agent> update()
    {
        ArrayList<Agent> reps = new ArrayList<>(Arrays.asList(this));
        if (t >= tMax) return reps;
        
        float amt = 1.0 * t / tMax;
        stroke(255);
        strokeWeight(lerp(sw, 0, pow(amt, swExp)));
        point(x, y);
        
        var d = getGrad(x, y, depth);
        
        var rShift = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
        rShift.normalize();
        rShift.mult(randAmt);
        d.mult(1 - randAmt);
        d.add(rShift);
        d.normalize();
        
        float yShift = pow(amt, yShiftExp) * yShiftMax;
        d.y += abs(d.y) * yShift;
        d.normalize();
        
        float x1 = x + d.x * len / tMax, y1 = y + d.y * len / tMax;
        
        if (random(1) < branchProb && depth < depthMax)
        {
            reps.add(new Branch(x, y, random(branchLenMin, branchLenMax), branchScale * sw, t, depth + 1));
        }
        
        ++t;
        x = x1; y = y1;
        return reps;
    }
}

ArrayList<Agent> agents = new ArrayList<>();

void update()
{
    ArrayList<Agent> tmp = new ArrayList<>();
    for (var a : agents)
    {
        tmp.addAll(a.update());
    }
    agents = tmp;
}

void setupA()
{
    float xScale = 60, yScale = 80;
    agents.add(new Trunk((char)('A'), xScale, yScale, xScale * 5 * 0.7, yScale * 5 * 0.3));
}

void setupAlphabet()
{
    float xScale = 30, yScale = 40;
    for (int i = 0; i < 26; ++i)
    {
        agents.add(new Trunk((char)('A' + i), xScale, yScale, xScale * 5 * (i % 5 * 1.4 + 0.7), yScale * 5 * (i / 5 * 1.4 + 0.4)));
    }
}

void setupTitle()
{
    float xScale = 15, yScale = 20;
    String text = "ILLEGIBLE BLACK METAL BAND LOGO GENERATOR";

    for (int i = 0; i < text.length(); ++i)
    {
        if (text.charAt(i) != ' ')
        {
            agents.add(new Trunk(text.charAt(i), xScale, yScale, xScale * 5 * (i % 22 * 1.4 + 0.8), yScale * 5 * (i / 22 * 1.4 + 0.6)));
        }
    }
}

void setupPoster()
{
    float xScale = 90, yScale = 120;
    for (int i = 0; i < 26; ++i)
    {
        agents.add(new Trunk((char)('A' + i), xScale, yScale, xScale * 5 * (i % 5 * 1.4 + 0.7), yScale * 5 * (i / 5 * 1.3 + 0.4)));
    }
}

void setup()
{   
    randomSeed(13);
    noiseSeed(666);
    
    buildAlphabet();
    
    //size(700, 700);
    //background(0);
    //setupA();
    
    size(1200, 1800);
    background(0);
    setupAlphabet();
    //beginRecord(PDF, "alphabet.pdf");
    //for (int i = 0; i < 400; ++i)
    //{
    //    update();
    //    if (i % 20 == 0) println(i);
    //}
    //println("Almost");
    //endRecord();
    //println("Done");
    
    //size(2400, 500);
    //background(0);
    //setupTitle();
    
    //size(3508, 4961);
    //background(0);
    //setupPoster();
    
    //testField();
}

void draw()
{
    update();
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}

/* Testing code for drawing the alphabet

final int xScale = 20, yScale = 30;
final int segCnt = 200;
final float swMin = 5, swMax = 15;
final float smoothAmt = 0.2;

void drawSeg(float x0, float y0, float x1, float y1, float swBeg, float swEnd)
{
    stroke(255);
    for (int i = 0; i < segCnt; ++i)
    {
        strokeWeight(map(i, 0, segCnt - 1, swBeg, swEnd));
        point(map(i, 0, segCnt - 1, x0, x1), map(i, 0, segCnt - 1, y0, y1));
    }
}

void drawArc(float x0, float y0, float x1, float y1, float x2, float y2, float swBeg, float swEnd)
{
    stroke(255);
    for (int i = 0; i < segCnt; ++i)
    {
        strokeWeight(map(i, 0, segCnt - 1, swBeg, swEnd));
        point(map(i, 0, segCnt - 1, map(i, 0, segCnt - 1, x0, x1), map(i, 0, segCnt - 1, x1, x2)),
              map(i, 0, segCnt - 1, map(i, 0, segCnt - 1, y0, y1), map(i, 0, segCnt - 1, y1, y2)));
    }
}

void testAlphabet()
{
    for (int i = 0; i < 26; ++i)
    {
        pushMatrix();
        translate(xScale * 5 * (i % 5 + 1), yScale * 5 * (i / 5 + 1));
        drawChar((char)('A' + i));
        popMatrix();
    }
}

void drawChar(Character c)
{
    var charStrokes = strokes.get(c);
    for (var s : charStrokes)
    {
        for (int i = 0; i + 1 < s.size(); i += 1)
        {
            float x0 = s.get(i) % 5, y0 = s.get(i) / 5;
            float x1 = s.get(i + 1) % 5, y1 = s.get(i + 1) / 5;
            x0 *= xScale; y0 *= yScale;
            x1 *= xScale; y1 *= yScale;
            float sw0 = map(i, 0, s.size() - 1, swMin, swMax);
            float sw1 = map(i + 1, 0, s.size() - 1, swMin, swMax);
            
            float xBeg, yBeg;
            float swBeg;
            if (i == 0)
            {
                xBeg = x0; yBeg = y0;
                swBeg = sw0;
            }
            else
            {
                xBeg = lerp(x0, x1, smoothAmt); yBeg = lerp(y0, y1, smoothAmt);
                swBeg = lerp(sw0, sw1, smoothAmt);
            }
            
            if (i + 2 < s.size())
            {
                float xEnd = lerp(x0, x1, 1 - smoothAmt), yEnd = lerp(y0, y1, 1 - smoothAmt);
                float swEnd = lerp(sw0, sw1, 1 - smoothAmt);
                drawSeg(xBeg, yBeg, xEnd, yEnd, swBeg, swEnd);
                
                float x2 = s.get(i + 2) % 5, y2 = s.get(i + 2) / 5;
                x2 *= xScale; y2 *= yScale;
                float sw2 = map(i + 2, 0, s.size() - 1, swMin, swMax);
                
                float xExt = lerp(x1, x2, smoothAmt), yExt = lerp(y1, y2, smoothAmt);
                float swExt = lerp(sw1, sw2, smoothAmt);
                drawArc(xEnd, yEnd, x1, y1, xExt, yExt, swEnd, swExt);
            }
            else
            {
                drawSeg(xBeg, yBeg, x1, y1, swBeg, sw1);
            }
        }
    }
}
//*/

void testField()
{
    for (int i = 0; i < width; ++i)
    {
        for (int j = 0; j < height; ++j)
        {
            var d = getGrad(i, j, 0);
            strokeWeight(2);
            stroke(100 * map(d.x, -1, 1, 0, 1), 100 * map(d.y, -1, 1, 0, 1), 0);
            point(i, j);
        }
    }
}
