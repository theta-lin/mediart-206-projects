public class AgentSprite extends Sprite
{
    protected PImage armImg;
    
    public AgentSprite(String basePath, String armPath)
    {
        super(basePath);
        armImg = loadImage(armPath);
    }
    
    @Override
    public void render(GameObject obj)
    {
        super.render(obj);
        
        if (obj.logic instanceof AgentLogic)
        {
            var logic = (AgentLogic) obj.logic;
            
            float x = obj.body.cx * pxPerM * pxScale;
            float y = (obj.body.cy * pxPerM - obj.body.cly) * pxScale;
            
            floating.noStroke();
            floating.fill(64);
            floating.rect(x - 3.5 * pxScale, y - 4 * pxScale, 8 * pxScale, 2 * pxScale);
            floating.fill(255, 0, 0);
            floating.rect(x - 3.5 * pxScale, y - 4 * pxScale, max(logic.hp, 0) * 8 * pxScale, 2 * pxScale);
            
            drawImg(armImg, obj.body.cx * pxPerM, obj.body.cy * pxPerM, 1, 0.5, logic.armDir, 1, floating);
        }
    }
}
