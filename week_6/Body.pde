public class Body
{
    private final float g = 9.8;
    
    public float cx, cy;
    public float rho;
    public float e;
    public float mu;
    public float vx = 0, vy = 0;
    public float ax = 0, ay = 0;
    
    public float M;
    
    public float theta;
    public float omega = 0;
    
    public float I;
    
    public int wBody, hBody;
    public boolean[][] mask;
    public float clx, cly;
    public int nUnit;
    
    private float fixedRotation = 0;
    private float thetaFixed = 0;
    
    public float impPreX = 0;
    public float impPreY = 0;
    public float impPreSum = 0;
    
    public int burns = 0;
    
    public boolean dead = false;
    
    public Body(float cx, float cy, float rho, float e, float mu, float theta, boolean[][] mask)
    {
        this.cx = cx; this.cy = cy;
        this.theta = theta;
        this.rho = rho;
        this.e = e;
        this.mu = mu;
        this.mask = mask;
        
        updateBody();
    }
    
    private Body(ObjectInputStream in) throws IOException, ClassNotFoundException
    {
        cx = in.readFloat(); cy = in.readFloat();
        rho = in.readFloat();
        e = in.readFloat();
        mu = in.readFloat();
        vx = in.readFloat(); vy = in.readFloat();
        
        theta = in.readFloat();
        omega = in.readFloat();
        
        wBody = in.readInt();
        hBody = in.readInt();
        mask = new boolean[wBody][hBody];
        for (int i = 0; i < wBody; ++i)
        for (int j = 0; j < hBody; ++j)
        {
            mask[i][j] = in.readBoolean();
        }
        
        fixedRotation = in.readFloat();
        thetaFixed = in.readFloat();
        
        updateBody();
    }
    
    public void writeObject(ObjectOutputStream out) throws IOException
    {
        out.writeFloat(cx); out.writeFloat(cy);
        out.writeFloat(rho);
        out.writeFloat(e);
        out.writeFloat(mu);
        out.writeFloat(vx); out.writeFloat(vy);
        
        out.writeFloat(theta);
        out.writeFloat(omega);
        
        out.writeInt(wBody);
        out.writeInt(hBody);
        for (int i = 0; i < wBody; ++i)
        for (int j = 0; j < hBody; ++j)
        {
            out.writeBoolean(mask[i][j]);
        }
        
        out.writeFloat(fixedRotation);
        out.writeFloat(thetaFixed);
    }
    
    public void updateBody()
    {
        wBody = mask.length; hBody = mask[0].length;
        
        M = 0;
        I = 0;
        clx = 0; cly = 0;
        nUnit = 0;
        
        for (int i = 0; i < wBody; ++i)
        for (int j = 0; j < hBody; ++j)
        {
            if (mask[i][j])
            {
                M += rho * mPerPx * mPerPx;
                clx += i; cly += j;
                ++nUnit;
            }
        }
        clx /= nUnit; cly /= nUnit;
        
        for (int i = 0; i < wBody; ++i)
        for (int j = 0; j < hBody; ++j)
        {
            if (mask[i][j])
            {
                float dx = (i - clx) * mPerPx, dy = (j - cly) * mPerPx;
                I += rho * mPerPx * mPerPx * ((dx * dx + dy * dy) + 1.0 / 6);
            }
        }
    }
    
    PVector toGlobal(float x, float y)
    {
         return toGlobal(x, y, cos(theta), sin(theta));
    }
    
    PVector toGlobal(float x, float y, float ct, float st)
    {
         PVector p = new PVector();
         p.x = cx + ((x - clx) * ct - (y - cly) * st) * mPerPx;
         p.y = cy + ((x - clx) * st + (y - cly) * ct) * mPerPx;
         return p;
    }
    
    PVector toLocal(float x, float y)
    {
        return toLocal(x, y, cos(theta), sin(theta));
    }
    
    PVector toLocal(float x, float y, float ct, float st)
    {
        PVector p = new PVector();
        p.x = clx + (x - cx) * pxPerM * ct + (y - cy) * pxPerM * st;
        p.y = cly + (y - cy) * pxPerM * ct - (x - cx) * pxPerM * st;
        return p;
    }
    
    public void project(ArrayList<Body>[][] occupation, ArrayList<Float>[][] cpxs, ArrayList<Float>[][] cpys)
    {
        float ct = cos(theta), st = sin(theta);

        float x0Rot = -clx * ct + cly * st;
        float y0Rot = -cly * ct - clx * st;
        float x1Rot = (wBody - clx) * ct + cly * st;
        float y1Rot = -cly * ct + (wBody - clx) * st;
        float x2Rot = (wBody - clx) * ct - (hBody - cly) * st;
        float y2Rot = (hBody - cly) * ct + (wBody - clx) * st;
        float x3Rot = -clx * ct - (hBody - cly) * st;
        float y3Rot = (hBody - cly) * ct - clx * st;
        
        for (int i = max(floor(cx * pxPerM + min(min(x0Rot, x1Rot), min(x2Rot, x3Rot))), 0);
             i <= min(ceil(cx * pxPerM + max(max(x0Rot, x1Rot), max(x2Rot, x3Rot))), wMap - 1);
             ++i)
        for (int j = max(floor(cy * pxPerM + min(min(y0Rot, y1Rot), min(y2Rot, y3Rot))), 0);
             j <= min(ceil(cy * pxPerM + max(max(y0Rot, y1Rot), max(y2Rot, y3Rot))), hMap - 1);
             ++j)
        {
            PVector p = toLocal(i * mPerPx, j * mPerPx, ct, st);
            for (int[] n : getNearest(p.x, p.y))
            {
                if (0 <= n[0] && n[0] < wBody && 0 <= n[1] && n[1] < hBody && mask[n[0]][n[1]])
                {
                    PVector cp = toGlobal(n[0], n[1], ct, st);
                    occupation[i][j].add(this);
                    cpxs[i][j].add(cp.x);
                    cpys[i][j].add(cp.y);
                }
            }
        }
    }
    
    public void setFixedRotation(float amt)
    {
        fixedRotation = amt;
        thetaFixed = theta;
    }
    
    private int[][] getNearest(float x, float y)
    {
        return new int[][]
            {
                {floor(x), floor(y)},
                {ceil(x), floor(y)},
                {floor(x), ceil(y)},
                {ceil(x), ceil(y)}
            };
    }
    
    public PVector getVp(float cpx, float cpy)
    {
        return new PVector(vx - omega * (cpy - cy), vy + omega * (cpx - cx));
    }
    
    public float getInvEffectiveM(float cpx, float cpy, float nx, float ny)
    {
        PVector r = new PVector(cpx - cx, cpy - cy);
        r.normalize();
        float cross = ny * r.x - nx * r.y;
        return cross * cross / I + 1 / M;
    }
    
    public void applyForces(float dt)
    {
        vx += ax * dt;
        vy += (ay + g) * dt;
        omega = fixedRotation * (thetaFixed - theta) / dt;
        
        ax = 0;
        ay = 0;
    }
    
    public void applyImpulse(float cpx, float cpy, float Jx, float Jy, boolean record)
    {
        vx += Jx / M;
        vy += Jy / M;
        float rx = cpx - cx, ry = cpy - cy;
        omega += (Jy * rx - Jx * ry) / I;
        
        if (record)
        {
            impPreX += Jx / M;
            impPreY += Jy / M;
            impPreSum += sqrt(Jx * Jx + Jy * Jy);
        }
    }
    
    public void applyImpulse(float cpx, float cpy, float Jx, float Jy)
    {
        applyImpulse(cpx, cpy, Jx, Jy, true);
    }
    
    public void updatePosition(float dt)
    {
        cx += vx * dt;
        cy += vy * dt;
        theta += omega * dt;
    }
    
    public void clearPre()
    {
        impPreX = 0;
        impPreY = 0;
        impPreSum = 0;
        burns = 0;
    }
}
