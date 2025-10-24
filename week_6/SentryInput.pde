public class SentryInput implements Input
{
    public final float dir;
    private final int msCastOilBottle = 2700;
    private final int msCastSpark = 3000;
    private int msPreCast = msCur;
    private boolean spark = false;
    
    public SentryInput(float dir)
    {
        this.dir = dir;
    }
    
    @Override
    public void handleInput(GameObject obj)
    {
        if (obj.logic instanceof AgentLogic)
        {
            var logic = (AgentLogic) obj.logic;
            logic.armDir = dir;
            if (!spark && msCur - msPreCast >= msCastOilBottle)
            {
                logic.castOilBottle(obj);
                spark = true;
            }
            else if (spark && msCur - msPreCast >= msCastSpark)
            {
                msPreCast = msCur;
                logic.castSpark(obj);
                spark = false;
            }
        }
    }
}
