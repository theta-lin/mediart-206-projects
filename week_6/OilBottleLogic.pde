public class OilBottleLogic implements Logic
{
    private final float breakImp = 2.5;
    private final int s = 7;
    
    @Override
    public void update(GameObject obj, ArrayList<Body>[][] occupation)
    {
        if (obj.body.impPreSum >= breakImp)
        {
            obj.die();
            for (int i = (int)(obj.body.cx * pxPerM) - s; i <= (int)(obj.body.cx * pxPerM) + s; ++i)
            for (int j = (int)(obj.body.cy * pxPerM) - s; j <= (int)(obj.body.cy * pxPerM) + s; ++j)
            {
                if (inBound(i, j)) fallingSand.add(i, j, LiquidType.OIL);
            }
        }
    }
}
