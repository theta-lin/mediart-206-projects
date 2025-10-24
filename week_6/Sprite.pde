public class Sprite
{
    protected PImage baseImg;
    
    public Sprite(String path)
    {
        baseImg = loadImage(path);
    }
    
    public void render(GameObject obj)
    {
        drawImg(baseImg, obj.body.cx * pxPerM, obj.body.cy * pxPerM, obj.body.clx, obj.body.cly, obj.body.theta);
    }
    
    public void preview(float x, float y)
    {
        drawImg(baseImg, x * pxPerM, y * pxPerM, baseImg.width / 2, baseImg.height / 2, 0, 0.5, null);
    }
    
    public boolean[][] getMask()
    {
        baseImg.loadPixels();
        boolean[][] mask = new boolean[baseImg.width][baseImg.height];
        for (int i = 0; i < baseImg.width; ++i)
        for (int j = 0; j < baseImg.height; ++j)
        {
            mask[i][j] = alpha(baseImg.pixels[i + j * baseImg.width]) > 0;
        }
        return mask;
    }
    
    protected void drawImg(PImage img, float cx, float cy, float clx, float cly, float theta)
    {
        drawImg(img, cx, cy, clx, cly, theta, 1, null);
    }
    
    protected void drawImg(PImage img, float cx, float cy, float clx, float cly, float theta, float alpha, PGraphics graphics)
    {
        float ct = cos(theta), st = sin(theta);
        
        float x0Rot = -clx * ct + cly * st;
        float y0Rot = -cly * ct - clx * st;
        float x1Rot = (img.width - clx) * ct + cly * st;
        float y1Rot = -cly * ct + (img.width - clx) * st;
        float x2Rot = (img.width - clx) * ct - (img.height - cly) * st;
        float y2Rot = (img.height - cly) * ct + (img.width - clx) * st;
        float x3Rot = -clx * ct - (img.height - cly) * st;
        float y3Rot = (img.height - cly) * ct - clx * st;
        
        //strokeWeight(10);
        //noFill();
        //stroke(0, 0, 255);
        //point((body.cx * pxPerM + x0Rot) * pxScale, (body.cy * pxPerM + y0Rot) * pxScale);
        //stroke(0, 255, 255);
        //point((body.cx * pxPerM + x1Rot) * pxScale, (body.cy * pxPerM + y1Rot) * pxScale);
        //stroke(255, 0, 255);
        //point((body.cx * pxPerM + x2Rot) * pxScale, (body.cy * pxPerM + y2Rot) * pxScale);
        //stroke(255, 255, 255);
        //point((body.cx * pxPerM + x3Rot) * pxScale, (body.cy * pxPerM + y3Rot) * pxScale);
        
        if (graphics == null)
        {
            noStroke();
        }
        else
        {
            graphics.noStroke();
        }
        
        img.loadPixels();
        for (int i = max(floor(cx + min(min(x0Rot, x1Rot), min(x2Rot, x3Rot))), 0);
             i <= min(ceil(cx + max(max(x0Rot, x1Rot), max(x2Rot, x3Rot))), wMap - 1);
             ++i)
        for (int j = max(floor(cy + min(min(y0Rot, y1Rot), min(y2Rot, y3Rot))), 0);
             j <= max(ceil(cy + max(max(y0Rot, y1Rot), max(y2Rot, y3Rot))), hMap - 1);
             ++j)
        {
            float x = clx + (i - cx) * ct + (j - cy) * st;
            float y = cly + (j - cy) * ct - (i - cx) * st;
            int xi = (int) floor(x), yi = (int) floor(y);
            float xf = x - xi, yf = y - yi;
            
            color[][] c = getNearestColors(img.pixels, img.width, img.height, xi, yi);
            color cc = lerpFill(lerpFill(c[0][0], c[1][0], xf), lerpFill(c[0][1], c[1][1], xf), yf);
            
            if (graphics == null)
            {
                fill(red(cc), green(cc), blue(cc), alpha(cc) * alpha);
                rect(i * pxScale, j * pxScale, pxScale, pxScale);
            }
            else
            {
                graphics.fill(red(cc), green(cc), blue(cc), alpha(cc) * alpha);
                graphics.rect(i * pxScale, j * pxScale, pxScale, pxScale);
            }
        }
    }
    
    private color getColor(color[] p, int w, int h, int i, int j)
    {
        if (0 <= i && i < w && 0 <= j && j < h)
        {
            return p[i + j * w];
        }
        else
        {
            return color(0, 0, 0, 0);
        }
    }
    
    private color[][] getNearestColors(color[] p, int w, int h, int i, int j)
    {
        color[][] res = new int[2][2];
        for (int di = 0; di < 2; ++di)
        for (int dj = 0; dj < 2; ++dj)
        {
            res[di][dj] = getColor(p, w, h, i + di, j + dj);
        }
        return res;
    }
    
    private color lerpFill(color a, color b, float amt)
    {
        if (alpha(a) == 0) return color(red(b), green(b), blue(b), alpha(b) * amt);
        if (alpha(b) == 0) return color(red(a), green(a), blue(a), alpha(a) * (1 - amt));
        return lerpColor(a, b, amt);
    }
}
