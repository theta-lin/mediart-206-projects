public enum LiquidType
{
    BURNING_OIL,
    OIL,
    WATER,
    SIZE;
}

public class FallingSand
{
    public final float[] viscosity = {0.5, 0.5, 0.2};
    public final color[] col = {color(255, 255, 0), color(120, 80, 0), color(0, 0, 255)};
    
    private final int liquidSize = LiquidType.SIZE.ordinal();
    private final int minTime = 1500, maxTime = 2500;
    private final float igniteChance = 0.04;
    private final int burnDecay = 5;
    
    private int[][][] map;
    private int[][] flow;
    private int[][] time;
    private boolean[][] decor;
    public boolean[][] solid;
    
    private ArrayList<Body>[][] occupation;
    
    public FallingSand()
    {
        map = new int[wMap][hMap][liquidSize];
        flow = new int[wMap][hMap];
        time = new int[wMap][hMap];
        decor = new boolean[wMap][hMap];
        solid = new boolean[wMap][hMap];
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            flow[i][j] = (random(2) < 1 ? -1 : 1);
        }
    }
    
    public FallingSand(ObjectInputStream in) throws IOException, ClassNotFoundException
    {
        map = new int[wMap][hMap][liquidSize];
        flow = new int[wMap][hMap];
        time = new int[wMap][hMap];
        decor = new boolean[wMap][hMap];
        solid = new boolean[wMap][hMap];
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        for (int k = 0; k < liquidSize; ++k)
        {
            map[i][j][k] = in.readInt();
        }
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            flow[i][j] = in.readInt();
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            time[i][j] = in.readInt();
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            decor[i][j] = in.readBoolean();
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            solid[i][j] = in.readBoolean();
        }
    }
    
    public void writeObject(ObjectOutputStream out) throws IOException
    {
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        for (int k = 0; k < liquidSize; ++k)
        {
            out.writeInt(map[i][j][k]);
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            out.writeInt(flow[i][j]);
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            out.writeInt(time[i][j]);
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            out.writeBoolean(decor[i][j]);
        }
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            out.writeBoolean(solid[i][j]);
        }
    }
    
    public void update(ArrayList<Body>[][] occupation)
    {
        this.occupation = occupation;
        
        int[][][] nxtMap = new int[wMap][hMap][liquidSize];
        int[][] nxtFlow = new int[wMap][hMap];
        int[][] nxtTime = new int[wMap][hMap];
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            if (time[i][j] > 0) time[i][j] -= round(random(1, burnDecay));
            time[i][j] = max(time[i][j], 0);
            if (time[i][j] == 0) map[i][j][LiquidType.BURNING_OIL.ordinal()] = 0;
        }
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            for (int di = -1; di <= 1; ++di)
            for (int dj = -1; dj <= 1; ++dj)
            {
                int ii = i + di, jj = j + dj;
                if (inBound(ii, jj) && map[ii][jj][LiquidType.BURNING_OIL.ordinal()] > 0)
                {
                    for (Body b : occupation[i][j]) ++b.burns;
                    
                    if (map[i][j][LiquidType.OIL.ordinal()] > 0 && random(1) < igniteChance)
                    {
                        nxtMap[i][j][LiquidType.BURNING_OIL.ordinal()] += map[i][j][LiquidType.OIL.ordinal()];
                        map[i][j][LiquidType.OIL.ordinal()] = 0;
                        nxtTime[i][j] = round(random(minTime, maxTime));
                    }
                }
            }
        }
        
        for (int j = hMap - 1; j >= 0; --j)
        {
            if (random(2) < 1)
            {
                for (int i = 0; i < wMap; ++i) updateDown(nxtMap, nxtFlow, nxtTime, i, j);
            }
            else
            {
                for (int i = wMap - 1; i >= 0; --i) updateDown(nxtMap, nxtFlow, nxtTime, i, j);
            }
        }
        
        for (int j = 0; j < hMap; ++j)
        {
            if (random(2) < 1)
            {
                for (int i = 0; i < wMap; ++i) updateUp(nxtMap, nxtTime, i, j);
            }
            else
            {
                for (int i = wMap - 1; i >= 0; --i) updateUp(nxtMap, nxtTime, i, j);
            }
        }
        
        for (int i = 0; i < wMap; ++i)
        for (int j = hMap - 1; j >= 0; --j)
        {
            for (int k = 0; k < liquidSize; ++k)
            {
                if (k == LiquidType.BURNING_OIL.ordinal() && map[i][j][k] > 0) nxtTime[i][j] = time[i][j];
                nxtMap[i][j][k] += map[i][j][k];
            }
        
            if (nxtFlow[i][j] == 0) nxtFlow[i][j] = flow[i][j];
        }
        
        map = nxtMap;
        flow = nxtFlow;
        time = nxtTime;
    }
    
    private void updateDown(int[][][] nxtMap, int[][] nxtFlow, int[][] nxtTime, int i, int j)
    {
        int[] cur = map[i][j];
        int dir = flow[i][j];
            
        if (!available(i, j))
        {
            /*for (int ii = i + dir; inBound(ii, j); ii += dir)
            {
                if (available(ii, j))
                {
                    for (int k = 0; k < liquidSize; ++k)
                    {
                        if (k == LiquidType.BURNING_OIL.ordinal() && cur[k] > 0) nxtTime[ii][j] = time[i][j];
                        nxtMap[ii][j][k] += cur[k];
                        cur[k] = 0;
                    }
                    nxtFlow[ii][j] = dir;
                    break;
                }
            } //*/
            return;
        }
            
        for (int k = liquidSize - 1; k >= 0; --k)
        {
            if (cur[k] > 0)
            {
                if (available(i, j + 1) && !heavier(i, j + 1, k))
                {
                    ++nxtMap[i][j + 1][k];
                    --cur[k];
                    if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i][j + 1] = time[i][j];
                }
                else if ((available(i - 1, j + 1) && !heavier(i - 1, j + 1, k)) && (!available(i + 1, j + 1) || heavier(i + 1, j + 1, k)))
                {
                    ++nxtMap[i - 1][j + 1][k];
                    nxtFlow[i - 1][j + 1] = -1;
                    --cur[k];
                    if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i - 1][j + 1] = time[i][j];
                }
                else if ((available(i + 1, j + 1) && !heavier(i + 1, j + 1, k)) && (!available(i - 1, j + 1) || heavier(i - 1, j + 1, k)))
                {
                    ++nxtMap[i + 1][j + 1][k];
                    nxtFlow[i + 1][j + 1] = 1;
                    --cur[k];
                    if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i + 1][j + 1] = time[i][j];
                }
                else if ((available(i - 1, j + 1) && !heavier(i - 1, j + 1, k)) && (available(i + 1, j + 1) && !heavier(i + 1, j + 1, k)))
                {
                    ++nxtMap[i + dir][j + 1][k];
                    nxtFlow[i + dir][j + 1] = dir;
                    --cur[k];
                    if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i + dir][j + 1] = time[i][j];
                }
                else if (random(1) > viscosity[k])
                { 
                    if ((available(i - 1, j) && !heavier(i - 1, j, k)) && (!available(i + 1, j) || heavier(i + 1, j, k)))
                    {
                        ++nxtMap[i - 1][j][k];
                        nxtFlow[i - 1][j] = -1;
                        --cur[k];
                        if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i - 1][j] = time[i][j];
                    }
                    else if ((available(i + 1, j) && !heavier(i + 1, j, k)) && (!available(i - 1, j) || heavier(i - 1, j, k)))
                    {
                        ++nxtMap[i + 1][j][k];
                        nxtFlow[i + 1][j] = 1;
                        --cur[k];
                        if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i + 1][j] = time[i][j];
                    }
                    else if ((available(i - 1, j) && !heavier(i - 1, j, k)) && (available(i + 1, j) && !heavier(i + 1, j, k)))
                    {
                        ++nxtMap[i + dir][j][k];
                        nxtFlow[i + dir][j] = dir;
                        --cur[k];
                        if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i + dir][j] = time[i][j];
                    }
                }
                break;
            }
        }
    }
    
    private void updateUp(int[][][] nxtMap, int[][] nxtTime, int i, int j)
    {
        if (!available(i, j)) return;
        
        int[] cur = map[i][j];
        int tot = count(i, j);
        if (tot > 1)
        {
            for (int k = 0; k < liquidSize; ++k)
            {
                if (cur[k] > 0)
                {
                    if (available(i, j - 1))
                    {
                        ++nxtMap[i][j - 1][k];
                        --cur[k];
                        if (k == LiquidType.BURNING_OIL.ordinal()) nxtTime[i][j - 1] = time[i][j];
                    }
                    
                    break;
                }
            }
        }
    }
    
    private boolean available(int i, int j)
    {
        return inBound(i, j) && occupation[i][j].size() == 0 && !solid[i][j];
    }
    
    private int count(int i, int j)
    {
        int tot = 0;
        for (int n : map[i][j]) tot += n;
        return tot;
    }
    
    private boolean heavier(int i, int j, int k)
    {
        for (int kk = k; kk < liquidSize; ++kk)
        {
            if (map[i][j][kk] > 0) return true;
        }
        return false;
    }
    
    public void render()
    {
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            noStroke();
            
            if (decor[i][j])
            {
                fill(255);
                rect(i * pxScale, j * pxScale, pxScale, pxScale);
            }
            
            int tot = count(i, j);
            if (tot > 0)
            {
                {
                    float r = map(noise(i * 0.1, j * 0.1, msCur * 0.005), 0, 1, 200, 255);
                    float g = map(noise((wMap + i) * 0.1, (hMap + j) * 0.1, msCur * 0.01), 0, 1, 0.1 * r, 0.9 * r);
                    fill(r, g, 0, 255.0 * map[i][j][LiquidType.BURNING_OIL.ordinal()] / tot);
                    rect(i * pxScale, j * pxScale, pxScale, pxScale);
                }
                
                color c;
                c = col[LiquidType.OIL.ordinal()];
                fill(red(c), green(c), blue(c), 255.0 * map[i][j][LiquidType.OIL.ordinal()] / tot);
                rect(i * pxScale, j * pxScale, pxScale, pxScale);
                c = col[LiquidType.WATER.ordinal()];
                fill(red(c), green(c), blue(c),255.0 * map[i][j][LiquidType.WATER.ordinal()] / tot);
                rect(i * pxScale, j * pxScale, pxScale, pxScale);
            }
            
            if (solid[i][j])
            {
                fill(100);
                rect(i * pxScale, j * pxScale, pxScale, pxScale);
            }
        }
    }
    
    public void add(int i, int j, LiquidType t)
    {
        ++map[i][j][t.ordinal()];
        if (t == LiquidType.BURNING_OIL) time[i][j] = round(random(minTime, maxTime));
    }
    
    public void addDecor(int i, int j)
    {
        decor[i][j] = true;
    }
    
    public void addSolid(int i, int j)
    {
        solid[i][j] = true;
    }
    
    public void remove(int i, int j)
    {
        for (int k = 0; k < liquidSize; ++k) map[i][j][k] = 0;
        decor[i][j] = false;
        solid[i][j] = false;
    }

    public void ignite(int i, int j)
    {
        map[i][j][LiquidType.BURNING_OIL.ordinal()] += map[i][j][LiquidType.OIL.ordinal()];
        map[i][j][LiquidType.OIL.ordinal()] = 0;
        time[i][j] = round(random(minTime, maxTime));
    }
}
