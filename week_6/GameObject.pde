public class GameObject
{
    public String type;
    public Input input;
    public Logic logic;
    public Sprite sprite;
    public Body body;
    
    public boolean dead = false;
    
    public GameObject(String type, Input input, Logic logic, Sprite sprite, Body body)
    {
        this.type = type;
        this.input = input;
        this.logic = logic;
        this.sprite = sprite;
        this.body = body;
    }
    
    public void handleInput()
    {
        if (input != null) input.handleInput(this);
    }
    
    public void update(ArrayList<Body>[][] occupation)
    {
        if (body.dead)
        {
            dead = true;
            return;
        }
        if (logic != null) logic.update(this, occupation);
    }
    
    public void render()
    {
        sprite.render(this);
    }
    
    public void die()
    {
        dead = true;
        body.dead = true;
    }
}
