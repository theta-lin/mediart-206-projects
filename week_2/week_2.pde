void setup()
{
    size(1000, 1000);
}

//final int n = 20, m = 20;
final int n = 33, m = 33;

int shift = 0;

color largeColor(int i, int j)
{
    colorMode(RGB, 1.0);
    if ((i + j) % 2 == 0)
    {
        return color(#C87941);
        //return color(0.6);
    }
    else
    {
        return color(#87431D);
        //return color(0.4);
    }
}

boolean oddBits(int x)
{
    boolean f = true;
    while (x > 0)
    {
        if (x % 2 == 1) f = !f;
        x >>= 1;
    }
    return f;
}

color smallColor(int i, int j)
{
    colorMode(RGB, 1.0);
    
    //if (((i - j) % 5 + 5) % 5 >= 3)
    //if ((i + j) % 2 == 0)
    
    //int c = i % 8;
    //int c = ((i - 4 * j) % 8 + 8) % 8;
    //if (c == 0 || c == 3 || c == 5 || c == 6)
    //if ((int) random(2) == 1)
    
    //0 1 2 3 4 5 6 7
    //*     *   * *
    
    //0110 1001 1
    
    
    //final int m = 8;
    //int s = ((i - j) % m + m) % m;
    //boolean a = (s + m / 8) % (m / 2) < m / 4;
    //boolean b = s % 8 < m / 2;
    //if (a == b)
    
    if (oddBits(((i - j + shift) % (n - 1) + (n - 1)) % (n - 1)))
    
    //for (int k = 0; k <= j; ++k) if (oddBits(k)) ++i;
    //if (oddBits(i))
    {
        return color(#DBCBBD);
        //return color(1.0);
    }
    else
    {
        return color(#290001);
        //return color(0.0);
    }
}

void draw()
{   
    for (int i = 0; i < n; ++i)
    for (int j = 0; j < m; ++j)
    {
        noStroke();
        fill(largeColor(i, j));
        float w = 1.0 * width / n, h = 1.0 * height / m;
        rect(i * w, j * h, w, h);
    }
    
    final float smallRatio = 0.5;
    
    //randomSeed(666);
    for (int i = 0; i < n - 1; ++i)
    for (int j = 0; j < m - 1; ++j)
    {
        noStroke();
        fill(smallColor(i, j));
        float w = 1.0 * width / n, h = 1.0 * height / m;
        float ws = smallRatio * w, hs = smallRatio * h;
        //rect((i + 1) * w - 0.5 * ws, (j + 1) * h - 0.5 * hs, ws, hs);
        
        pushMatrix();
        translate((i + 1) * w, (j + 1) * h);
        beginShape();
        vertex(0.5 * ws, 0);
        quadraticVertex(0, 0, 0, 0.5 * hs);
        quadraticVertex(0, 0, -0.5 * ws, 0);
        quadraticVertex(0, 0, 0, -0.5 * hs);
        quadraticVertex(0, 0, 0.5 * ws, 0);
        endShape();
        popMatrix();
    }
    
    if (frameCount % 20 == 0) ++shift;
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}
