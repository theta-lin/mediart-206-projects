import java.io.*;

int msCur, msPre, msLag = 0;
final int msPerUpdate = 10;

final int pxScale = 8;
int wMap, hMap;
final int boundrySize = 2;
final int pxPerM = 8;
final float mPerPx = 1.0 / pxPerM;
final float exitSize = 0.02;

FallingSand fallingSand;
RigidSim rigidSim;
private ArrayList<GameObject> objs, toSpawns;

PGraphics floating;

Logic agentLogic, oilBottleLogic, sparkLogic;
Sprite boxSprite, plankSprite, playerSprite, enemySprite, sentrySprite, oilBottleSprite, sparkSprite;

boolean[] keyDown;

boolean editor = false;
boolean[][] remove;

int levelId = 0;
int levelFinal = 15;

float sentryDir = 0;

void setup()
{
    size(1920, 1080);
    floating = createGraphics(width, height);
    wMap = width / pxScale;
    hMap = height / pxScale;
    toSpawns = new ArrayList<GameObject>();
    
    frameRate(60);
    msPre = millis();
    
    oilBottleLogic = new OilBottleLogic();
    sparkLogic = new SparkLogic();
    
    boxSprite = new Sprite("spr/box.png");
    plankSprite = new Sprite("spr/plank.png");
    playerSprite = new AgentSprite("spr/player.png", "spr/player_arm.png");
    enemySprite = new AgentSprite("spr/enemy.png", "spr/enemy_arm.png");
    sentrySprite = new AgentSprite("spr/sentry.png", "spr/enemy_arm.png");
    oilBottleSprite = new Sprite("spr/oil_bottle.png");
    sparkSprite = new Sprite("spr/spark.png");
    
    keyDown = new boolean[1 << 16];
    remove = new boolean[wMap][hMap];
    
    read();
}

void draw()
{
    msCur = millis();
    msLag += msCur - msPre;
    msPre = msCur;
    
    objs.addAll(toSpawns);
    toSpawns.clear();
    
    if (!editor)
    {
        for (var obj : objs) obj.handleInput();
    }

    while (msLag >= msPerUpdate)
    {
        var occupation = rigidSim.update();
        fallingSand.update(occupation);
        
        if (editor)
        {
            for (int i = 0; i < wMap; ++i)
            for (int j = 0; j < hMap; ++j)
            {
                if (remove[i][j])
                {
                    for (Body obj : occupation[i][j])
                    {
                        obj.dead = true;
                    }
                    remove[i][j] = false;
                }
            }
        }
        
        var nxt = new ArrayList<GameObject>();
        for (var obj : objs)
        {
            obj.update(occupation);
            if (!obj.dead) nxt.add(obj);
        }
        objs = nxt;
        
        msLag -= msPerUpdate;
    }
    
    background(0);
    fallingSand.render();
    floating.beginDraw();
    floating.clear();
    for (var obj : objs) obj.render();
    floating.endDraw();
    image(floating, 0, 0);
    
    if (editor)
    {
        renderPreview();
        fill(255, 0, 0);
        textSize(32);
        textAlign(RIGHT, TOP);
        text("EDITOR", width, 0); 
        
        if ((choice == 0 || choice == 1 || choice == 10) && mousePressed && mouseButton == LEFT)
        {
            int im = mouseX / pxScale, jm = mouseY / pxScale;
            addSand(im, jm);
        }
    }
    
    fill(255);
    textSize(32);
    textAlign(LEFT, TOP);
    text("LEVEL " + levelId, 0, 0);
    
    if (levelId < levelFinal)
    {
        boolean clear = true;
        boolean atExit = false;
        for (var obj : objs)
        {
            if (obj.type.equals("Enemy") || obj.type.equals("Sentry"))
            {
                clear = false;
            }
            else if (obj.type.equals("Player"))
            {
                if (obj.body.cx >= (1 - exitSize) * wMap * mPerPx) atExit = true;
            }
        }
        noStroke();
        fill(clear ? color(0, 255, 0, 128) : color(255, 0, 0, 128));
        rect((1 - exitSize) * width, 0, exitSize * width, height);
        if (clear && atExit)
        {
            ++levelId;
            read();
        }
    }
    
    /*var occupation = rigidSim.update();
    for (int i = 0; i < wMap; ++i)
    for (int j = 0; j < hMap; ++j)
    {
        if (occupation[i][j].size() > 0)
        {
            fill(255, 0, 0, 100);
            rect(i * pxScale, j * pxScale, pxScale, pxScale);
        }
    }//*/
}

void write()
{   
    String filename = sketchPath("lvl/" + levelId + ".lvl");
    try (ObjectOutputStream outputStream = new ObjectOutputStream(new FileOutputStream(filename)))
    {
        fallingSand.writeObject(outputStream);
        
        outputStream.writeInt(objs.size());
        for (var obj : objs)
        {
            outputStream.writeObject(obj.type);
            if (obj.type.equals("Sentry")) outputStream.writeFloat(((SentryInput) obj.input).dir);
            obj.body.writeObject(outputStream);
        }
        println("Level saved: " + filename);
    }
    catch (IOException e)
    {
        println("Error saving: " + filename);
        //e.printStackTrace();
    }
}

void read()
{
    rigidSim = new RigidSim();
    objs = new ArrayList<GameObject>();
    
    String filename = sketchPath("lvl/" + levelId + ".lvl");
    try (ObjectInputStream inputStream = new ObjectInputStream(new FileInputStream(filename)))
    {
        fallingSand = new FallingSand(inputStream);
        
        int n = inputStream.readInt();
        for (int i = 0; i < n; ++i)
        {
            String type = (String) inputStream.readObject();
            float sentryDir = 0;
            if (type.equals("Sentry")) sentryDir = inputStream.readFloat();
            Body body = new Body(inputStream);
            rigidSim.add(body);
            
            switch (type)
            {
            case "Box":
                objs.add(new GameObject("Box", null, null, boxSprite, body));
                break;
                
            case "Plank":
                objs.add(new GameObject("Plank", null, null, plankSprite, body));
                break;
                
            case "OilBottle":
                objs.add(new GameObject("OilBottle", null, oilBottleLogic, oilBottleSprite, body));
                break;
            
            case "Spark":
                objs.add(new GameObject("Spark", null, sparkLogic, sparkSprite, body));
                break;
            
            case "Player":
                objs.add(new GameObject("Player", new PlayerInput(), new AgentLogic(), playerSprite, body));
                break;
            
            case "Enemy":
                objs.add(new GameObject("Enemy", new EnemyInput(), new AgentLogic(), enemySprite, body));
                break;
                
            case "Sentry":
                objs.add(new GameObject("Sentry", new SentryInput(sentryDir), new AgentLogic(), sentrySprite, body));
                break;
            }
        }
        println("Level loaded: " + filename);
    }
    catch (IOException | ClassNotFoundException e)
    {
        fallingSand = new FallingSand();
        println("Error loading: " + filename);
         //e.printStackTrace();
    }
}

int choice = 0;
int sBrush = 5;

void addSand(int im, int jm)
{
    for (int i = im - sBrush; i <= im + sBrush; ++i)
    for (int j = jm - sBrush; j <= jm + sBrush; ++j)
    {
        if (!inBound(i, j)) continue;
        
        switch (choice)
        {
        case 1:
            fallingSand.addSolid(i, j);
            break;
            
        case 2:
            fallingSand.add(i, j, LiquidType.OIL);
            break;
            
        case 0:
            fallingSand.addDecor(i, j);
            break;
            
        case 10:
            fallingSand.remove(i, j);
            break;
        }
    }
}

void previewSand(int im, int jm)
{
    for (int i = im - sBrush; i <= im + sBrush; ++i)
    for (int j = jm - sBrush; j <= jm + sBrush; ++j)
    {
        if (!inBound(i, j)) continue;
        
        color c = 0;
        
        switch (choice)
        {
        case 1:
            c = color(100);
            break;
            
        case 2:
            c = fallingSand.col[LiquidType.OIL.ordinal()];
            break;
            
        case 0:
            c = color(255);
            break;
            
        case 10:
            c = ((i + j) % 2 == 0 ? color(0) : color(255));
            break;
        }
        
        noStroke();
        fill(red(c), green(c), blue(c), 128);
        rect(i * pxScale, j * pxScale, pxScale, pxScale);
    }
}

boolean inBound(float i, float j)
{
    return boundrySize <= i && i < wMap - boundrySize && boundrySize <= j && j < hMap - boundrySize;
}

void keyPressed()
{
    keyDown[key] = true;
    
    if (key == '`') editor = !editor;
    
    if (key == 'p') read();
    
    if (editor)
    {
        if (keyCode == BACKSPACE) choice = 10;
        
        switch(key)
        {
        case '0':
            choice = 0;
            break;
            
        case '1':
            choice = 1;
            break;
            
        case '2':
            choice = 2;
            break;
            
        case '3':
            choice = 3;
            break;
        
        case '4':
            choice = 4;
            break;
            
        case '5':
            choice = 5;
            break;
            
        case '6':
            choice = 6;
            break;
            
        case '7':
            choice = 7;
            break;
            
        case '8':
            choice = 8;
            break;
            
        case '9':
            choice = 9;
            break;
        }
        
        if (keyCode == TAB) write();
        
        if (keyCode == LEFT)
        {
            --levelId;
            read();
        }
        
        if (keyCode == RIGHT)
        {
            ++levelId;
            read();
        }
    }  
    
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}

void renderPreview()
{
    int im = mouseX / pxScale, jm = mouseY / pxScale;
    
    switch (choice)
    {
    case 0:
    case 1:
    case 2:
    case 10:
        previewSand(im, jm);
        break;
        
    case 3:
        boxSprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 4:
        plankSprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 5:
        oilBottleSprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 6:
        sparkSprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 7:
        playerSprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 8:
        enemySprite.preview(im * mPerPx, jm * mPerPx);
        break;
        
    case 9:
        sentrySprite.preview(im * mPerPx, jm * mPerPx);
        strokeWeight(10);
        stroke(255, 0, 0, 200);
        line(im * pxScale, jm * pxScale, im * pxScale + 100 * cos(sentryDir), jm * pxScale + 100 * sin(sentryDir));
        break;
    }
}

void keyReleased()
{
    keyDown[key] = false;
}

void mousePressed()
{
    if (!editor) return;
    
    int im = mouseX / pxScale, jm = mouseY / pxScale;
    
    if (mouseButton == LEFT)
    {
        switch (choice)
        {
        case 2:
            addSand(im, jm);
            break;

        case 3:
            Body boxBody = new Body(im * mPerPx, jm * mPerPx, 0.5, 0.2, 0.2, 0, boxSprite.getMask());
            rigidSim.add(boxBody);
            objs.add(new GameObject("Box", null, null, boxSprite, boxBody));
            break;
            
        case 4:
            Body plankBody = new Body(im * mPerPx, jm * mPerPx, 0.5, 0.2, 0.2, 0, plankSprite.getMask());
            rigidSim.add(plankBody);
            objs.add(new GameObject("Plank", null, null, plankSprite, plankBody));
            break;
            
        case 5:
            createOilBottle(im * mPerPx, jm * mPerPx, 0, 0);
            break;
            
        case 6:
            createSpark(im * mPerPx, jm * mPerPx, 0, 0);
            break;
            
        case 7:
            Body playerBody = new Body(im * mPerPx, jm * mPerPx, 2, 0, 0.4, 0, playerSprite.getMask());
            rigidSim.add(playerBody);
            GameObject player = new GameObject("Player", new PlayerInput(), new AgentLogic(), playerSprite, playerBody);
            player.body.setFixedRotation(0.05);
            objs.add(player);
            break;
            
        case 8:
            Body enemyBody = new Body(im * mPerPx, jm * mPerPx, 1, 0, 0.2, 0, enemySprite.getMask());
            rigidSim.add(enemyBody);
            GameObject enemy = new GameObject("Enemy", new EnemyInput(), new AgentLogic(), enemySprite, enemyBody);
            enemy.body.setFixedRotation(0.05);
            objs.add(enemy);
            break;
            
        case 9:
            Body sentryBody = new Body(im * mPerPx, jm * mPerPx, 1, 0, 0.2, 0, sentrySprite.getMask());
            rigidSim.add(sentryBody);
            GameObject sentry = new GameObject("Sentry", new SentryInput(sentryDir), new AgentLogic(), sentrySprite, sentryBody);
            sentry.body.setFixedRotation(0.05);
            objs.add(sentry);
            break;
        }
    }
    
    if (mouseButton == RIGHT)
    {
        if (inBound(im, jm)) remove[im][jm] = true;
    }
}

void mouseWheel(MouseEvent event)
{
    float e = event.getCount();
    if (choice == 0 || choice == 1 || choice == 2 || choice == 10)
    {
        if (e < 0)
        {
            --sBrush;
        }
        else
        {
            ++sBrush;
        }
        
        sBrush = max(sBrush, 0);
    }
    if (choice == 9)
    {
        sentryDir += e * 0.2;
    }
}

void createSpark(float x, float y, float vx, float vy)
{
    Body sparkBody = new Body(x, y, 0.01, 0, 0, 0, sparkSprite.getMask());
    sparkBody.vx = vx;
    sparkBody.vy = vy;
    rigidSim.add(sparkBody);
    toSpawns.add(new GameObject("Spark", null, sparkLogic, sparkSprite, sparkBody));
}

void createOilBottle(float x, float y, float vx, float vy)
{
    Body oilBottleBody = new Body(x, y, 1, 0, 0.25, 0, oilBottleSprite.getMask());
    oilBottleBody.vx = vx;
    oilBottleBody.vy = vy;
    rigidSim.add(oilBottleBody);
    toSpawns.add(new GameObject("OilBottle", null, oilBottleLogic, oilBottleSprite, oilBottleBody));
}
