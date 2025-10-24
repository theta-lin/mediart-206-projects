public class EnemyInput implements Input
{
    private final int msChange = 1000;
    private int msPreInput = -msChange;
    
    private boolean[] dir = new boolean[4];
    
    public EnemyInput()
    {
    }
    
    @Override
    public void handleInput(GameObject obj)
    {
        if (msCur - msPreInput >= msChange)
        {
            msPreInput = msCur;
            for (int i = 0; i < 4; ++i) dir[i] = (random(2) < 1);
        }
        
        float f = constrain(-obj.body.impPreY * 300, 0, 1);
        
        if (dir[0]) obj.body.vy = max(obj.body.vy - 6 * f, -6);
        if (dir[1]) obj.body.ay += 30;
        
        if (dir[2] && obj.body.vx > -7)
        {
            obj.body.ax += -150 * f;
        }
        if (dir[3] && obj.body.vx < 7)
        {
            obj.body.ax += 150 * f;
        }
    }
}
