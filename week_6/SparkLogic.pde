public class SparkLogic implements Logic
{
    final int s = 2;
    
    @Override
    public void update(GameObject obj, ArrayList<Body>[][] occupation)
    {
        for (int i = (int)(obj.body.cx * pxPerM) - s; i <= (int)(obj.body.cx * pxPerM) + s; ++i)
        for (int j = (int)(obj.body.cy * pxPerM) - s; j <= (int)(obj.body.cy * pxPerM) + s; ++j)
        {
            if (inBound(i, j)) fallingSand.ignite(i, j);
        }
        
        if (obj.body.impPreSum > 0)
        {
            rigidSim.remove(obj.body);
            obj.dead = true;
        }
    }
}
