public class PlayerInput implements Input
{
    private final int msCast = 500;
    private int msPreCast = -msCast;
    
    @Override
    public void handleInput(GameObject obj)
    {
        float f = constrain(-obj.body.impPreY * 300, 0, 1);
        
        if (keyDown['w']) obj.body.vy = max(obj.body.vy - 6 * f, -6);
        if (keyDown['s']) obj.body.ay += 30;
        
        if (keyDown['a'] && obj.body.vx > -7)
        {
            obj.body.ax += -200 * f;
        }
        if (keyDown['d'] && obj.body.vx < 7)
        {
            obj.body.ax += 200 * f;
        }
        
        if (obj.logic instanceof AgentLogic)
        {
            var logic = (AgentLogic) obj.logic;
            logic.armDir = atan2(mouseY - obj.body.cy * pxPerM * pxScale, mouseX - obj.body.cx * pxPerM * pxScale);
            logic.grab = (mousePressed && mouseButton == LEFT);
            if (mousePressed && mouseButton == RIGHT)
            {
                if (msCur - msPreCast >= msCast)
                {
                    msPreCast = msCur;
                    logic.castSpark(obj);
                }
            }
        }
    }
}
