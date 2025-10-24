// DEPENDENCIES:
// This specific fork of Video Export Library: https://github.com/hamoid/video_export_processing/tree/kotlinGradle
// And ffmpeg
// Or just comment out all the code containing video export
import com.hamoid.*;

import java.util.Arrays;
import java.util.List;
import java.util.Comparator;

final int sLog = 7;
final int s = 1 << sLog;           // The image is of size s * s
final int nColors = 1 << 12;       // Number of colors in RGB12
final int nPalette = 1 << 4;       // A 16-color palette is used
final int threshold = 3;           // How different the colors in the palette must be
int[] palette = new int[nPalette];

int[] iMove = {1, 0, -1, 0};
int[] jMove = {0, 1, 0, -1};

final float eps = 1e-9;

int toRgb12(int c)
{
    // RRRRRRRR GGGGGGGG BBBBBBBB
    // ****     ****     **** 
    //    20       12       4
    
    int r = c >> 20 & 0xF, g = c >> 12 & 0xF, b = c >> 4 & 0xF;
    return (r << 8) + (g << 4) + b;
}

int fromRgb12(int c)
{
    int r = c >> 8 & 0xF, g = c >> 4 & 0xF, b = c & 0xF;
    return (r << 20) + (g << 12) + (b << 4);
}

int distRgb12(int a, int b)
{
    return abs((a >> 8 & 0xF) - (b >> 8 & 0xF)) + abs((a >> 4 & 0xF) - (b >> 4 & 0xF)) + abs((a & 0xF) - (b & 0xF));
}

int[] toColors(int[] a)
{
    int[] b = new int[a.length];
    for (int i = 0; i < a.length; ++i) b[i] = palette[a[i]];
    return b;
}

int avgRgb12(int[] a)
{
    int r = 0, g = 0, b = 0;
    for (int c : a)
    {
        r += c >> 8 & 0xF;
        g += c >> 4 & 0xF;
        b += c & 0xF;
    }
    
    r /= a.length;
    g /= a.length;
    b /= a.length;
    return (r << 8) + (g << 4) + b;
}

int fitToPalette(int c)
{
    int closest = 0;
    for (int i = 1; i < nPalette; ++i)
    {
        if (distRgb12(c, palette[i]) < distRgb12(c, palette[closest]))
        {
            closest = i;
        }
    }
    return closest;
}

// As not all colors in the palette might be present when averaging pixels at a large scale,
// only those colors that are present are considered when fitting the average color into the palette
int fitToPalette(int c, int[] cnts)
{
    int closest = -1;
    for (int i = 0; i < nPalette; ++i)
    {
        if (cnts[i] > 0 && (closest == -1 || distRgb12(c, palette[i]) < distRgb12(c, palette[closest])))
        {
            closest = i;
        }
    }
    return closest;
}

ArrayList<Integer> toArrayList(int a[])
{
    var al = new ArrayList<Integer>();
    for (int i : a) al.add(i);
    return al;
}

// Fit the image into a 16-color palette
int[] quantize(PImage input)
{
    Integer[] count = new Integer[nColors];
    Integer[] value = new Integer[nColors];
    for (int i = 0; i < nColors; ++i) count[i] = 0;
    for (int i = 0; i < nColors; ++i) value[i] = i;
    
    // Convert to RGB12 (using 4 bits for each color channel)`
    input.loadPixels();
    for (int i = 0; i < s * s; ++i) ++count[toRgb12(input.pixels[i])];
    
    Comparator<Integer> cmp = new Comparator<Integer>() {
        @Override
        public int compare(Integer i, Integer j) {
            return Integer.compare(count[j], count[i]);
        }
    };
    Arrays.sort(value, cmp);
    
    // Add colors to the palette starting from the color that occurred the most
    // Skip the colors that are too similar to each other
    int cur = 0;
    for (int i = 0; i < nColors && cur < nPalette; ++i)
    {
        boolean similar = false;
        for (int j = 0; j < cur; ++j)
        {
            if (distRgb12(palette[j], value[i]) < threshold)
            {
                similar = true;
                break;
            }
        }
        if (!similar)
        {
            palette[cur++] = value[i];
        }
    }
    
    if (cur < nPalette)
    {
        for (int i = 0; i < nPalette; ++i)
        {
            palette[i] = value[i];
        }
    }
    
    int[] quantized = new int[s * s];
    for (int i = 0; i < s * s; ++i)
    {
        int c = toRgb12(input.pixels[i]);
        quantized[i] = 0;
        for (int j = 1; j < nPalette; ++j)
        {
            if (distRgb12(c, palette[j]) < distRgb12(c, palette[quantized[i]]))
            {
                quantized[i] = j;
            }
        }
    }
    return quantized;
}

/*
 * Using 2x2 tiles as an example:
 *
 * 11 22
 * 11 22
 *
 * 33 44
 * 33 44
 */

int[][] tilelify(int[] img, int nTiles, int sTiles)
{
    int[][] tiles = new int[nTiles * nTiles][sTiles * sTiles];
    
    for (int ti = 0; ti < nTiles; ++ti)
    for (int tj = 0; tj < nTiles; ++tj)
    {
        for (int di = 0; di < sTiles; ++di)
        for (int dj = 0; dj < sTiles; ++dj)
        {
            tiles[ti * nTiles + tj][di * sTiles + dj] = img[(ti * sTiles + di) * (nTiles * sTiles) + (tj * sTiles + dj)];
        }
    }
    
    return tiles;
}

int[] untilelify(int[][] tiles, int nTiles, int sTiles)
{
    int[] img = new int[(nTiles * sTiles) * (nTiles * sTiles)];
    
    for (int ti = 0; ti < nTiles; ++ti)
    for (int tj = 0; tj < nTiles; ++tj)
    {
        for (int di = 0; di < sTiles; ++di)
        for (int dj = 0; dj < sTiles; ++dj)
        {
            img[(ti * sTiles + di) * (nTiles * sTiles) + (tj * sTiles + dj)] = tiles[ti * nTiles + tj][di * sTiles + dj];
        }
    }
    
    return img;
}

// Randomly select a index given an array of weights
// Zero weighted indices are ignored and -1 will be returned if all weights are zero
int weightSel(float[] w)
{
    int n = 0;
    for (float x : w)
    {
        if (abs(x) > eps) ++n;
    }
    int[] pos = new int[n];
    {
        int i = 0;
        for (int j = 0; j < w.length; ++j)
        {
            if (abs(w[j]) > eps) pos[i++] = j;
        }
    }
    
    float sum = 0;
    for (int i : pos) sum += w[i];
    
    int i = 0;
    float rand = random(sum);
    float cur = 0;
    while (i < n)
    {
        cur += w[pos[i]];
        if (rand < cur) break;
        ++i;
    }
    if (i == n) --i;
    if (i == -1) return -1;
    return pos[i];
}

// Log for for each step of wave function collapse
ArrayList<Integer> colLog;

// Execute one step of wave function collapse
void collapse(int[] target, float[] pTot, float[][][] pAdj, int n)
{
    // Find all empty tiles
    int cnt = 0;
    for (int i : target) cnt += (i == -1) ? 1 : 0;
    int[] pos = new int[cnt];
    {
        int i = 0;
        for (int j = 0; j < n * n; ++j)
        {
            if (target[j] == -1) pos[i++] = j;
        }
    }
    
    // THESE ARE NOT ACTUALLY USED:
    // Find all tiles with minimum entropy
    // This is used in the original wave function collapse algorithm
    // But my algorithm randomly selects tiles
    // Tiles with less entropy is more likely to be selected
    // float minEntropy = Float.POSITIVE_INFINITY;
    // var minIndices = new ArrayList<Integer>();
    
    float maxEntropy = Float.NEGATIVE_INFINITY;
    float[] entropy = new float[cnt];
    
    // Join probablity of a color being placed in a position
    float[][] p = new float[cnt][nPalette];
    
    for (int k = 0; k < cnt; ++k)
    {
        int i = pos[k] / n, j = pos[k] % n;
        for (int c = 0; c < nPalette; ++c)
        {
            p[k][c] = pTot[c];
            for (int m = 0; m < 4; ++m)
            {
                int ii = i + iMove[m], jj = j + jMove[m];
                if (0 <= ii && ii < n && 0 <= jj && jj < n && target[ii * n + jj] != -1)
                {
                    int cc = target[ii * n + jj];
                    p[k][c] *= pAdj[m][c][cc] / pTot[cc];
                }
            }

            if (p[k][c] > 0) entropy[k] -= p[k][c] * log(p[k][c]);
        }
        
        // NOT USED:
        // if (minEntropy - entropy[k] > eps)
        // {
        //     minEntropy = entropy[k];
        //     minIndices = new ArrayList<Integer>();
        //     minIndices.add(k);
        // }
        // else if (entropy[k] - minEntropy < eps)
        // {
        //     minIndices.add(k);
        // }
        
        if (entropy[k] - maxEntropy > eps) maxEntropy = entropy[k];
    }
    
    for (int i = 0; i < cnt; ++i) entropy[i] = maxEntropy - entropy[i];

    // NOT USED:
    // int k = minIndices.get((int) random(minIndices.size()));
    
    int k = weightSel(entropy);
    if (k == -1) ++k;
    target[pos[k]] = weightSel(p[k]);
    colLog.add(pos[k]);
    if (target[pos[k]] == -1) target[pos[k]] = weightSel(pTot);
}

int[][] build(int[][] orig, int[][] tiles, int sTiles)
{
    int n = s / sTiles;
    
    var avgTiles = new ArrayList<ArrayList<ArrayList<Integer>>>();
    for (int i = 0; i < nPalette; ++i) avgTiles.add(new ArrayList<ArrayList<Integer>>());
    for (int[] tile : tiles)
    {
        int c = fitToPalette(avgRgb12(toColors(tile)));
        var al = toArrayList(tile);
        avgTiles.get(c).add(al);
    }
    int cnts[] = new int[nPalette];
    for (int i = 0; i < nPalette; ++i) cnts[i] = avgTiles.get(i).size();
    
    int[] avg = new int[n * n];
    float[] pTot = new float[nPalette];
    for (int i = 0; i < n * n; ++i)
    {
        avg[i] = fitToPalette(avgRgb12(toColors(orig[i])), cnts);
        ++pTot[avg[i]];
    }
    
    for (int i = 0; i < nPalette; ++i) pTot[i] /= n * n;
    
    /*   2
     * 3 x 1  P(x0), P(x1), P(x2), p(x3)
     *   0
     */
    
    float[][][] pAdj = new float[4][nPalette][nPalette];
    
    for (int m = 0; m < 4; ++m)
    for (int i = 0; i < n; ++i)
    for (int j = 0; j < n; ++j)
    {
        int ii = i + iMove[m], jj = j + jMove[m];
        if (0 <= ii && ii < n && 0 <= jj && jj < n)
        {
            int cur = avg[i * n + j], nxt = avg[ii * n + jj];
            ++pAdj[m][cur][nxt];
        }
    }
    
    for (int m = 0; m < 4; ++m)
    for (int i = 0; i < nPalette; ++i)
    {
        float sum = 0;
        for (int j = 0; j < nPalette; ++j) sum += pAdj[m][i][j];
        
        if (sum != 0)
        {
            for (int j = 0; j < nPalette; ++j) pAdj[m][i][j] /= sum;
        }
    }
    
    int[] avgRes = new int[n * n];
    for (int i = 0; i < n * n; ++i) avgRes[i] = -1;
    for (int i = 0; i < n * n; ++i)
    {
        collapse(avgRes, pTot, pAdj, n);
        if (i % n == 0) System.out.printf("%.2f%%\n", 100.0 * i / (n  * n));
    }
    
    int[][] tileRes = tilelify(avgRes, n / 2, 2);
    int[][] result = new int[(n / 2) * (n / 2)][(sTiles * 2) * (sTiles * 2)];
    for (int i = 0; i < (n / 2) * (n / 2); ++i)
    {
        int[][] tmp = new int[4][sTiles * sTiles];
        for (int j = 0; j < 4; ++j)
        {
            var group = avgTiles.get(tileRes[i][j]);
            if (group.size() == 0)
            {
                for (int k = 0; k < sTiles * sTiles; ++k) tmp[j][k] = tileRes[i][j];
            }
            else
            {
                int id = floor(random(group.size()));
                for (int k = 0; k < sTiles * sTiles; ++k) tmp[j][k] = group.get(id).get(k);
            }
        }
        result[i] = untilelify(tmp, 2, sTiles);
    }
    
    return result;
}

void apply(int[] target, int[] tile, int pos, int sTiles, int nTiles)
{
    int ti = pos / nTiles, tj = pos % nTiles;
    for (int i = 0; i < sTiles; ++i)
    for (int j = 0; j < sTiles; ++j)
    {
        target[(ti * sTiles + i) * s + (tj * sTiles + j)] = fromRgb12(palette[tile[i * sTiles + j]]);
    }
}

int[][][] iters = new int[sLog - 1][][];
int[][] colLogs = new int[sLog - 1][];

PImage output;
VideoExport video;

void setup()
{
    size(1024, 1024);
    output = createImage(s, s, RGB);
    video = new VideoExport(this, "collapse.mkv", output);
    video.startMovie();
    
    PImage input = loadImage("peppers.png");
    //PImage input = loadImage("house.png");
    //PImage input = loadImage("mandrill.png");
    input.resize(s, s);
    
    int[] quantized = quantize(input);
    int[][] tiles = new int[nPalette][1];
    for (int i = 0; i < tiles.length; ++i) tiles[i][0] = i;
    
    for (int i = 0; i < sLog - 1; ++i)
    {
        println("Iteration: " + i);
        int sTiles = 1 << i;
        int[][] tilelified = tilelify(quantized, s / sTiles, sTiles);
        
        colLog = new ArrayList<>();
        tiles = build(tilelified, tiles, sTiles);
        int[] unwrapped = untilelify(tiles, s / (sTiles * 2), sTiles * 2);
        iters[i] = tilelify(unwrapped, s / sTiles, sTiles);
        colLogs[i] = new int[colLog.size()];
        for (int j = 0; j < colLog.size(); ++j) colLogs[i][j] = colLog.get(j);
        
        int colors[] = toColors(unwrapped);
        output.loadPixels();
        for (int j = 0; j < s * s; ++j) output.pixels[j] = fromRgb12(colors[j]);
        output.updatePixels();
        output.save("iter_" + i + ".png");
    }
    
    // TESTS
    
    //output = createImage(s, s, RGB);
    //output.loadPixels();
    //input.loadPixels();
    //for (int i = 0; i < s * s; ++i) output.pixels[i] = fromRgb12(toRgb12(input.pixels[i]));
    //output.updatePixels();
    //output.save("1.png");
    
    //int[] quantized = quantize(input);
    //output = createImage(s, s, RGB);
    //output.loadPixels();
    //for (int i = 0; i < s * s; ++i) output.pixels[i] = fromRgb12(palette[quantized[i]]);
    //output.updatePixels();
    //output.save("2.png");
    
    //int[] quantized = quantize(input);
    //int[][] tilelified = tilelify(quantized, s / 4, 4);
    //output = createImage(s / 4, s / 4, RGB);
    //output.loadPixels();
    //for (int i = 0; i < tilelified.length; ++i) output.pixels[i] = fromRgb12(palette[tilelified[i][0]]);
    //output.updatePixels();
    //output.save("3.png");
}

int[] pLogs = new int[sLog - 1];

boolean done = false;

void draw()
{
    final int framesPerIter = 360;
    
    int iter = (frameCount - 1) / framesPerIter;
    
    if (iter < sLog - 1)
    {
        output.loadPixels();
        
        if (pLogs[iter] == 0)
        {
            for (int i = 0; i < output.pixels.length; ++i) output.pixels[i] = 0;
        }
        
        float amount = 1.0 * ((frameCount - 1) % framesPerIter) / framesPerIter;
        int n = colLogs[iter].length;
        
        while (pLogs[iter] < n && 1.0 * pLogs[iter] / n < amount)
        {
            int pos = colLogs[iter][pLogs[iter]];
            apply(output.pixels, iters[iter][pos], pos, 1 << iter, s / (1 << iter));
            ++pLogs[iter];
        }
        
        output.updatePixels();
        video.saveFrame();
    }
    else if (!done)
    {
        video.endMovie();
        done = true;
    }
    
    PImage screen = output.copy();
    screen.resize(width, height);
    image(screen, 0, 0);
}
