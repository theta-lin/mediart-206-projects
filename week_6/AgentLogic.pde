public class AgentLogic implements Logic
{
    public float hp = 1;
    
    private final float armLength = 11;
    public float armDir = HALF_PI;
    public boolean grab = false;
    private Body grabbing = null;
    private PVector contact;
    public float Fmax = 400;
    public float Fdrop = 1500;
    
    private final float vCast = 6;
    
    @Override
    public void update(GameObject obj, ArrayList<Body>[][] occupation)
    {
        hp -= obj.body.burns * 8e-5;
        
        if (hp <= 0)
        {
            rigidSim.remove(obj.body);
            obj.dead = true;
        }
        
        if (grab)
        {
            if (grabbing == null)
            {
                int i = round(obj.body.cx * pxPerM + cos(armDir) * armLength);
                int j = round(obj.body.cy * pxPerM + sin(armDir) * armLength);
                if (inBound(i, j) && occupation[i][j].size() > 0)
                {
                    Body b = occupation[i][j].get(0);
                    grabbing = b;
                    contact = b.toLocal(i * mPerPx, j * mPerPx);
                }
            }
        }
        else
        {
            grabbing = null;
        }
        
        if (grabbing != null && grabbing.dead) grabbing = null;
        
        if (grabbing != null)
        {
            float x = obj.body.cx + cos(armDir) * armLength * mPerPx;
            float y = obj.body.cy + sin(armDir) * armLength * mPerPx;
            
            if (inBound(x * pxPerM, y * pxPerM))
            {
                PVector p = grabbing.toGlobal(contact.x, contact.y);
                PVector J = new PVector(x - p.x, y - p.y);
                
                J.div(rigidSim.dt);
                J.x -= grabbing.vx;
                J.y -= grabbing.vy;
                J.mult(grabbing.M);
                
                float l = J.mag();
                if (l > Fdrop * rigidSim.dt)
                {
                    grabbing = null;
                }
                else
                {
                    J.mult(min(l, Fmax * rigidSim.dt) / l);
                    grabbing.applyImpulse(p.x, p.y, J.x, J.y, false);
                    obj.body.applyImpulse(x, y, -J.x * 0.1, -J.y * 0.1, false);
                }
            }
        }
    }
    
    public void castSpark(GameObject obj)
    {
        float x = obj.body.cx + cos(armDir) * armLength * mPerPx;
        float y = obj.body.cy + sin(armDir) * armLength * mPerPx;
        createSpark(x, y, obj.body.vx + cos(armDir) * vCast, obj.body.vy + sin(armDir) * vCast);
    }
    
    public void castOilBottle(GameObject obj)
    {
        float x = obj.body.cx + cos(armDir) * armLength * mPerPx;
        float y = obj.body.cy + sin(armDir) * armLength * mPerPx;
        createOilBottle(x, y, obj.body.vx + cos(armDir) * vCast, obj.body.vy + sin(armDir) * vCast);
    }
}
