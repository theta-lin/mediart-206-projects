public class RigidSim
{
    public final float dt = 1e-3 * msPerUpdate;
    private final float maxIter = 10;
    private final float beta = 1;
    private final float betaSolid = 5e-4;
    private ArrayList<Body> bodies = new ArrayList<Body>();
    
    public RigidSim()
    {
    }
    
    public ArrayList<Body>[][] update()
    {        
        var nxt = new ArrayList<Body>();
        for (Body b : bodies)
        {
            if (!b.dead) nxt.add(b);
        }
        bodies = nxt;
        
        ArrayList<Body>[][] occupation = new ArrayList[wMap][hMap];
        ArrayList<Float>[][] cpxs = new ArrayList[wMap][hMap];
        ArrayList<Float>[][] cpys = new ArrayList[wMap][hMap];
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            occupation[i][j] = new ArrayList<Body>();
            cpxs[i][j] = new ArrayList<Float>();
            cpys[i][j] = new ArrayList<Float>();
        }
        
        for (Body b : bodies) b.project(occupation, cpxs, cpys);
        
        for (Body b : bodies) b.applyForces(dt);
        
        for (Body b : bodies) b.clearPre();
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            if (fallingSand.solid[i][j])
            {
                for (int k = 0; k < occupation[i][j].size(); ++k)
                {
                    Body b = occupation[i][j].get(k);
                    float cpx = cpxs[i][j].get(k), cpy = cpys[i][j].get(k);
                    PVector n = new PVector(cpx - i * mPerPx, cpy - j * mPerPx);
                    float d = 1 - n.mag();
                    n.normalize();
                    if (d > 0) applyBorderImpulse(b, cpx, cpy, i * mPerPx, j * mPerPx, n.x, n.y, d);
                }
            }
            
            for (int ka = 0; ka < occupation[i][j].size(); ++ka)
            for (int kb = ka + 1; kb < occupation[i][j].size(); ++kb)
            {
                Body a = occupation[i][j].get(ka);
                float cpxa = cpxs[i][j].get(ka), cpya = cpys[i][j].get(ka);
                Body b = occupation[i][j].get(kb);
                float cpxb = cpxs[i][j].get(kb), cpyb = cpys[i][j].get(kb);
                
                float d = mPerPx - dist(cpxa, cpya, cpxb, cpyb);
                if (a != b && d > 0)
                {
                    PVector n = new PVector(cpxb - cpxa, cpyb - cpya);
                    n.normalize();
                    PVector t = new PVector(-n.y, n.x);
                    
                    float sumJn = 0;
                    for (int l = 0; l < maxIter; ++l)
                    {
                        PVector vpa = a.getVp(cpxa, cpya), vpb = b.getVp(cpxb, cpyb);

                        float vn = PVector.sub(vpb, vpa).dot(n);
                        float vBias = beta / dt * d;
                        float Jn = (1 + (a.e + b.e) / 2) * (-vn + vBias) / (a.getInvEffectiveM(cpxa, cpya, n.x, n.y) + b.getInvEffectiveM(cpxb, cpyb, n.x, n.y));
                        Jn = max(Jn, 0);
                        float oldJn = sumJn;
                        sumJn = max(sumJn + Jn, 0);
                        Jn = sumJn - oldJn;
                        
                        a.applyImpulse((cpxa + cpxb) / 2, (cpya + cpyb) / 2, -Jn * n.x, -Jn * n.y);
                        b.applyImpulse((cpxa + cpxb) / 2, (cpya + cpyb) / 2, Jn * n.x, Jn * n.y);
                        
                        float vt = PVector.sub(vpb, vpa).dot(t);
                        float Jt = (1 + (a.e + b.e) / 2) * -vt / (a.getInvEffectiveM(cpxa, cpya, t.x, t.y) + b.getInvEffectiveM(cpxb, cpyb, t.x, t.y));
                        Jt = constrain(Jt, -(a.mu + b.mu) / 2 * sumJn, (a.mu + b.mu) / 2 * sumJn);
                        a.applyImpulse(cpxa, cpya, -Jt * t.x, -Jt * t.y);
                        b.applyImpulse(cpxb, cpyb, Jt * t.x, Jt * t.y);
                    }
                }
            }
        }
        
        for (int i = 0; i < wMap; ++i)
        for (int j = 0; j < boundrySize; ++j)
        {
            for (int k = 0; k < occupation[i][j].size(); ++k)
            {
                Body b = occupation[i][j].get(k);
                float cpx = cpxs[i][j].get(k), cpy = cpys[i][j].get(k);
                
                float d = (boundrySize - 1) + mPerPx / 2 - cpy;
                if (d > 0) applyBorderImpulse(b, cpx, cpy, i * mPerPx, j * mPerPx, 0, 1, d);
            }
            
            for (int k = 0; k < occupation[i][hMap - 1 - j].size(); ++k)
            {
                Body b = occupation[i][hMap - 1 - j].get(k);
                float cpx = cpxs[i][hMap - 1 - j].get(k), cpy = cpys[i][hMap - 1 - j].get(k);
                
                float d = (boundrySize - 1) + cpy - (hMap * mPerPx - mPerPx / 2);
                if (d > 0) applyBorderImpulse(b, cpx, cpy, i * mPerPx, j * mPerPx, 0, -1, d);
            }
        }
        
        for (int i = 0; i < boundrySize; ++i)
        for (int j = 0; j < hMap; ++j)
        {
            for (int k = 0; k < occupation[i][j].size(); ++k)
            {
                Body b = occupation[i][j].get(k);
                float cpx = cpxs[i][j].get(k), cpy = cpys[i][j].get(k);
                
                float d = (boundrySize - 1) + mPerPx / 2 - cpx;
                if (d > 0) applyBorderImpulse(b, cpx, cpy, i * mPerPx, j * mPerPx, 1, 0, d);
            }
            
            for (int k = 0; k < occupation[wMap - 1 - i][j].size(); ++k)
            {
                Body b = occupation[wMap - 1 - i][j].get(k);
                float cpx = cpxs[wMap - 1 - i][j].get(k), cpy = cpys[wMap - 1 - i][j].get(k);
                
                float d = (boundrySize - 1) + mPerPx / 2 - (wMap * mPerPx - cpx);
                if (d > 0) applyBorderImpulse(b, cpx, cpy, i * mPerPx, j * mPerPx, -1, 0, d);
            }
        }
        
        for (Body b : bodies) b.updatePosition(dt);
        
        return occupation;
    }
    
    public void applyBorderImpulse(Body b, float cpx, float cpy, float bx, float by, float nx, float ny, float d)
    {
        float tx = -ny, ty = nx;
        
        float sumJn = 0;
        for (int i = 0; i < maxIter; ++i)
        {
            PVector vp = b.getVp(cpx, cpy);
            
            float vn = vp.x * nx + vp.y * ny;
            float vBias = betaSolid / dt * d;
            float Jn = (1 + b.e) * (-vn + vBias) / b.getInvEffectiveM(cpx, cpy, nx, ny);
            Jn = max(Jn, 0);
            float oldJn = sumJn;
            sumJn = max(sumJn + Jn, 0);
            Jn = sumJn - oldJn;
            b.applyImpulse((cpx + bx) / 2, (cpy + by) / 2, Jn * nx, Jn * ny);
            
            float vt = vp.x * tx + vp.y * ty;
            float Jt = (1 + b.e) * -vt / b.getInvEffectiveM(cpx, cpy, tx, ty);
            Jt = constrain(Jt, -b.mu * sumJn, b.mu * sumJn);
            b.applyImpulse(cpx, cpy, Jt * tx, Jt * ty);
        }
    }
    
    public void add(Body b)
    {
        bodies.add(b);
    }
    
    public void remove(Body b)
    {
        bodies.remove(b);
    }
}
