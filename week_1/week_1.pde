interface Callback
{
    void run(int i, int j);
}

// Tomorrow theme: https://github.com/chriskempson/tomorrow-theme
int[][] tomorrow = {{234, 234, 234},
                    {0, 0, 0},
                    {66, 66, 66},
                    {42, 42, 42},
                    {150, 152, 150},
                    {213, 78, 83},
                    {231, 140, 69},
                    {231, 197, 71},
                    {185, 202, 74},
                    {112, 192, 177},
                    {122, 166, 218},
                    {195, 151, 216},
                    {77, 80, 87}};

// I found that it is necessary to have strokes to fill the gaps between the triangle fans
void setColor(int r, int g, int b)
{
    strokeWeight(2);
    fill(r, g, b);
    stroke(r, g, b);
}

void setColor(int id)
{
    setColor(tomorrow[id][0], tomorrow[id][1], tomorrow[id][2]);
}

float s, w, h;

// Distance between to hexagonal points
int hexDist(int i0, int j0, int i1, int j1)
{
    return max(abs(i0 - i1), abs(j0 - j1), abs((i0 + j0) - (i1 + j1)));
}

// Rounding a point to the nearest hexagon
int[] hexRound(float x, float y)
{
    int[] result = {round(x), round(y)};
    float dx = x - result[0], dy = y - result[1];
    if (abs(dx) >= abs(dy))
    {
        result[0] += round(dx + 0.5 * dy);
    }
    else
    {
        result[1] += round(dy + 0.5 * dx);
    }
    return result;
}

// Convert screen pixel coordinate to hexagonal coordinate
// Hexagonal coordinate tricks: https://observablehq.com/@jrus/hexround
int[] pixelToHex(int pi, int pj)
{
    float x = (sqrt(3) / 3 * pi - 1.0 / 3 * pj) / s;
    float y = (                   2.0 / 3 * pj) / s;
    return hexRound(x, y);
}

void hexPoint(int i, int j, Callback callback)
{
    if (callback != null) callback.run(i, j);
    
    float x = (i + 0.5 * j) * w;
    float y = j * 0.75 * h;

    beginShape(TRIANGLE_FAN);
    vertex(x, y);
    vertex(x, y - 0.5 * h);
    vertex(x + 0.5 * w, y - 0.25 * h);
    vertex(x + 0.5 * w, y + 0.25 * h);
    vertex(x, y + 0.5 * h);
    vertex(x - 0.5 * w, y + 0.25 * h);
    vertex(x - 0.5 * w, y - 0.25 * h);
    vertex(x, y - 0.5 * h);
    endShape();
}

void hexPoint(int i, int j)
{
    hexPoint(i, j, null);
}

void hexCircle(int i, int j, int r, Callback callback)
{
    for (int di = -r; di <= r; ++di)
    {
        for (int dj = max(-r, -di - r); dj <= min(r, -di + r); ++dj)
        {
            hexPoint(i + di, j + dj, callback);
        }
    }
}

void hexCircle(int i, int j, int r)
{
    hexCircle(i, j, r, null);
}

void hexLine(int i0, int j0, int i1, int j1, Callback callback)
{
    int d = hexDist(i0, j0, i1, j1);
    for (int t = 0; t <= d; ++t)
    {
        float f = 1.0 * t / d;
        int[] pos = hexRound(lerp(i0, i1, f), lerp(j0, j1, f));
        hexPoint(pos[0], pos[1], callback);
    }
}

void hexLine(int i0, int j0, int i1, int j1)
{
    hexLine(i0, j0, i1, j1, null);
}

// Triangle drawing algorithm: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling#old-school-method-line-sweeping)
void hexTriangle(int i0, int j0, int i1, int j1, int i2, int j2, Callback callback)
{
    // I hate swapping in Java
    if (j0 > j1)
    {
        int t = i0; i0 = i1; i1 = t;
            t = j0; j0 = j1; j1 = t;
    }
    if (j0 > j2)
    {
        int t = i0; i0 = i2; i2 = t;
            t = j0; j0 = j2; j2 = t;
    }
    if (j1 > j2)
    {
        int t = i1; i1 = i2; i2 = t;
            t = j1; j1 = j2; j2 = t;
    }
    
    for (int j = j0; j <= j2; ++j)
    {
        float fa = lerp(i0, i2, 1.0 * (j - j0) / (j2 - j0));
        float fb = (j < j1 || j1 == j2) ? lerp(i0, i1, 1.0 * (j - j0) / (j1 - j0)) : lerp(i1, i2, 1.0 * (j - j1) / (j2 - j1));
        
        int a = hexRound(fa, j)[0];
        int b = hexRound(fb, j)[0];
        if (a > b) { int t = a; a = b; b = t; }
        for (int i = a; i <= b; ++i) hexPoint(i, j, callback);
    }
}

void hexTriangle(int i0, int j0, int i1, int j1, int i2, int j2)
{
    hexTriangle(i0, j0, i1, j1, i2, j2, null);
}

void hexQuad(int i0, int j0, int i1, int j1, int i2, int j2, int i3, int j3, Callback callback)
{
    hexTriangle(i0, j0, i1, j1, i2, j2, callback);
    hexTriangle(i0, j0, i2, j2, i3, j3, callback);
}

void hexQuad(int i0, int j0, int i1, int j1, int i2, int j2, int i3, int j3)
{
    hexQuad(i0, j0, i1, j1, i2, j2, i3, j3, null);
}

// Draw text with different colors
void drawText(String texts[], int cIds[], int x, int y)
{
    for (int i = 0; i < texts.length; ++i)
    {
        setColor(cIds[i]);
        text(texts[i], x, y);
        x += textWidth(texts[i]);
    }
}

void setup()
{
    // Force consistent result when re-run the program
    noiseSeed(666);
    
    size(1240, 1754);
    s = width / 60;    // Hexagon cell radius
    w = sqrt(3.0) * s; // Hexagon cell width
    h = 2.0 * s;       // Hexagon cell height

    background(0);

    //////////////////
    //// Graphics ////
    //////////////////
    
    // Laptop
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float scale = 0.2;
                            float amount = map(i, 2, 12, 0.8, 1) * map(noise(i * scale, j * scale), 0, 1, 0.5, 1);
                            setColor((int) lerp(0, tomorrow[7][0], amount), (int) lerp(0, tomorrow[7][1], amount), (int) lerp(0, tomorrow[7][2], amount));
                        }
                    };
        hexQuad(10, 22, 17, 26, 12, 35, 5, 32, callback);
        hexQuad(2, 33, 9, 38, 12, 35, 5, 32, callback);
    }
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float scale = 0.2;
                            float amount = map(i, 2, 12, 0.5, 0.9) * map(noise(i * scale, j * scale), 0, 1, 0.5, 1);
                            setColor((int) lerp(0, tomorrow[7][0], amount), (int) lerp(0, tomorrow[7][1], amount), (int) lerp(0, tomorrow[7][2], amount));
                        }
                    };
        hexPoint(6, 31, callback);
        hexPoint(7, 32, callback);
        hexPoint(8, 33, callback);
        hexPoint(9, 34, callback);
        hexPoint(10, 35, callback);
        hexPoint(5, 33, callback);
        hexPoint(6, 34, callback);
        hexPoint(7, 35, callback);
    }
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float amount = map(i, 7, 15, 0.7, 1.4);
                            setColor((int) lerp(0, tomorrow[10][0], amount), (int) lerp(0, tomorrow[10][1], amount), (int) lerp(0, tomorrow[10][2], amount));
                        }
                    };
        hexQuad(10, 24, 15, 27, 12, 33, 7, 30, callback);
    }
    
    // Coder
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float scale = 0.15;
                            float amount = map(i, -3, 6, 0.3, 1.2) * map(noise(i * scale, j * scale), 0, 1, 0.7, 1);
                            setColor((int) lerp(0, tomorrow[5][0], amount), (int) lerp(0, tomorrow[5][1], amount), (int) lerp(0, tomorrow[5][2], amount));
                        }
                    };
        hexCircle(4, 27, 2, callback);
        hexQuad(-1, 30, 5, 30, 3, 37, -3, 37, callback);
        hexQuad(-1, 38, 3, 36, 3, 39, -3, 41, callback);
    }
    
    // Left dude
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float scale = 0.15;
                            float amount = map(i, -29, -8, 0.1, 1.2) * map(noise(i * scale, j * scale), 0, 1, 0.6, 1);
                            setColor((int) lerp(0, tomorrow[10][0], amount), (int) lerp(0, tomorrow[10][1], amount), (int) lerp(0, tomorrow[10][2], amount));
                        }
                    };
        hexCircle(-16, 43, 8, callback);
        hexQuad(-24, 49, -13, 49, -14, 58, -29, 58, callback);
        
        setColor(1);
        hexLine(-16, 37, -10, 37);
        hexLine(-18, 39, -10, 39);
        hexCircle(-19, 42, 1);
        hexCircle(-12, 42, 1);
        hexCircle(-18, 47, 2);

        hexPoint(-19, 42, callback);
        hexPoint(-12, 42, callback);
        hexLine(-19, 47, -17, 47, callback);
    }
    
    // Right dude
    {
        Callback callback = new Callback() {
                        @Override
                        public void run(int i, int j)
                        {
                            float scale = 0.15;
                            float amount = map(j, 58, 41, 0.1, 1.2) * map(noise(i * scale, j * scale), 0, 1, 0.6, 1);
                            setColor((int) lerp(0, tomorrow[11][0], amount), (int) lerp(0, tomorrow[11][1], amount), (int) lerp(0, tomorrow[11][2], amount));
                        }
                    };
        hexCircle(8, 45, 4, callback);
        hexQuad(1, 49, 11, 49, 7, 58, -2, 58, callback);
        hexTriangle(0, 44, 2, 49, -1, 53, callback);
        hexTriangle(-1, 47, -1, 48, -2, 48, callback);
        
        setColor(1);
        hexLine(8, 42, 11, 42);
        hexCircle(6, 45, 1);
        hexCircle(10, 45, 1);
        hexCircle(6, 49, 1);
        
        hexPoint(6, 45, callback);
        hexPoint(10, 45, callback);
        hexPoint(6, 49, callback);
    }
    
    ///////////////
    //// Texts ////
    ///////////////

    // Brass Mono font: https://github.com/fonsecapeter/brass_mono
    PFont fontSmall = createFont("BrassMono.otf", 64);
    PFont fontLarge = createFont("BrassMono.otf", 128);
    textAlign(LEFT, TOP);
    textFont(fontSmall);
    {
        String[] texts = {"if", " (", "you", ".", "are"," == ", "\"1337 h@ck3r\"", ")"};
        int[] cIds     = {  11,    0,    7,    0,     10,     0,                 8, 0};
        drawText(texts, cIds, width / 12, 2 * height / 40);
    }
    {
        String[] texts = {"you", ".", "join", "("};
        int[] cIds     = {    7,   0,     10,   0};
        drawText(texts, cIds, 2 * width / 12, 4 * height / 40);
    }
    textFont(fontLarge);
    setColor(8);
    text("\"Programming\"", 3 * width / 12,  6 * height / 40);
    text(    "\"Contest\"", 3 * width / 12,  9 * height / 40);
    text(       "\"Club\"", 3 * width / 12, 12 * height / 40);
    textFont(fontSmall);
    setColor(0);
    text(");"             , 3 * width / 12, 15 * height / 40);
    
    //test();
}

void draw()
{
    // Tool for sketching and getting hexagonal coordinates
    // Not to be used for producing the final result
    if (mousePressed)
    {
        int[] mouseHex = pixelToHex(mouseX, mouseY);
        setColor(255, 0, 0);
        hexPoint(mouseHex[0], mouseHex[1]);
        println(mouseHex[0], mouseHex[1]);
    }
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}

// Testing code for the hexagonal tools
void test()
{
    background(255, 0, 0);
    
    int iNum = 40;
    int jNum = 60;
    
    for (int i = 0; i < iNum; ++i)
    {
        for (int j = 0; j < jNum; ++j)
        {
            int c = (int) (64 * noise((i - j / 2) * 0.1, j * 0.1));
            setColor(c, c, c);
            hexPoint(i - j / 2, j);
        }
    }
    
    setColor(255, 255, 255);
    hexCircle(10, 10, 4);
    hexLine(5, 16, 15, 24);
    
    setColor(255, 255, 255);
    hexTriangle(-5, 30, -15, 40, 2, 35);
    setColor(255, 0, 0);
    hexPoint(-5, 30);
    hexPoint(-15, 40);
    hexPoint(2, 35);
    
    Callback callback = new Callback() {
                            @Override
                            public void run(int i, int j)
                            {
                                float scale = 0.2;
                                float amount = noise(i * scale, j * scale);
                                setColor((int) lerp(64, 256, amount), (int) lerp(32, 128, amount), 0);
                            }
                        };
    hexQuad(-15, 50, 5, 45, 0, 50, -20, 55, callback);
}
