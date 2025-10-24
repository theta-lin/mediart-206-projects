import java.util.Arrays;

public interface Symbol
{
    void apply();
    ArrayList<Symbol> getReplacements();
}

public class LeftParen implements Symbol
{
    public void apply()
    {
        pushMatrix();
    }
    
    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps = new ArrayList<>(Arrays.asList(this));
        return reps;
    }
}

public class RightParen implements Symbol
{
    public void apply()
    {
        popMatrix();
    }
    
    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps = new ArrayList<>(Arrays.asList(this));
        return reps;
    }
}

/*
 * Branch: a cylinder with spheres at the end
 * Cylinder: https://vormplus.be/full-articles/drawing-a-cylinder-with-processing
 */

public static class BranchConf
{
    static float rMax = 15, rStep = 0.025;            // Radius
    static float hMax = 60, hStep = 0.15;             // Length
    static float mainRatio = 0.9, lateralRatio = 0.6; // Ratio of the radius of the new main/lateral branch compared to the current branch
    static float n = 3;                               // Number of lateral branches
    static float lateralPitch = PI / 3;               // Pitch of lateral branches
}

public class Branch implements Symbol
{
    private float r;
    private float h;
    private float roll;
    private float pitch;
    
    public Branch(float r, float h, float roll, float pitch)
    {
        this.r = r;
        this.h = h;
        this.roll = roll;
        this.pitch = pitch;
    }
    
    public void apply()
    {
        fill(120, 80, 0);
        noStroke();
        
        rotateY(roll);
        rotateX(pitch);
        
        int sides = 10;
        float angle = 2 * PI / sides;
        
        beginShape();
        for (int i = 0; i < sides + 1; ++i) vertex(r * sin(i * angle), 0, r * cos(i * angle));
        endShape();
        
        beginShape(TRIANGLE_STRIP);
        for (int i = 0; i < sides + 1; ++i)
        {
            vertex(r * sin(i * angle), 0, r * cos(i * angle));
            vertex(r * sin(i * angle), -h, r * cos(i * angle));
        }
        endShape();
        
        translate(0, -h, 0);
        
        beginShape();
        for (int i = 0; i < sides + 1; ++i) vertex(r * sin(i * angle), 0, r * cos(i * angle));
        endShape();
        sphere(r);
    }

    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps =
            new ArrayList<>(Arrays.asList(new Branch(min(r + BranchConf.rStep, BranchConf.rMax),
                                                     min(h + BranchConf.hStep, BranchConf.hMax),
                                                     roll,
                                                     pitch)));
        return reps;
    }
}

// Draw leaf/flower petal
void drawPiece(float l, float w, float ratio)
{
    int sides = 10     ;
    float angle = 2 * PI / sides;
    
    beginShape(TRIANGLE_FAN);
    vertex(0, 0, 0);
    for (int i = 0; i < sides + 1; ++i)
    {
        float curL = (sin(i * angle) < 0 ? ratio : 1 - ratio) * 2 * l;
        vertex(w * cos(i * angle), -curL * sin(i * angle), 0);
    }
    endShape();
}

/*
 * Leaf: Triangle fans drawn along a squashed circle
 *
 *
 *    <        l        >
 *  ^        |
 *           |
 *  w -------+-----------
 *           |
 *  v        |
 *    <ratio> <1 - ratio>
 *
 */

public static class LeafConf
{
    static float lMax = 12, lStep = 1;  // Length
    static float wMax = 6, wStep = 0.5; // Width
    static float ratio = 0.3;           // Determines the position of the leaf center along the major axis
    static float pitch = PI / 3;        // Pitch deviation from the branch that this leaf attaches to
}

public class Leaf implements Symbol
{
    private float branchR;
    private float l;
    private float w;
    private float roll;
    private float pitch;
    
    public Leaf(float branchR, float l, float w, float roll, float pitch)
    {
        this.branchR = branchR;
        this.l = l;
        this.w = w;
        this.roll = roll;
        this.pitch = pitch;
    }
    
    public void apply()
    {
        fill(20, 180, 0);
        strokeWeight(2);
        stroke(16, 140, 0);
        
        pushMatrix();
        rotateY(roll);
        rotateX(pitch);
        
        translate(0, -branchR - LeafConf.ratio * 2 * l, 0);
        drawPiece(l, w, LeafConf.ratio);
        popMatrix();
    }

    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps =
            new ArrayList<>(Arrays.asList(new Leaf(min(branchR + BranchConf.rStep, BranchConf.rMax),
                                                   min(l + LeafConf.lStep, LeafConf.lMax),
                                                   min(w + LeafConf.wStep, LeafConf.wMax),
                                                   roll,
                                                   pitch)));
        return reps;
    }
}

public static class FlowerConf
{
    static float lMax = 8, lStep = 1;    // Length of petal
    static float wMax = 4, wStep = 0.5;  // Width of petal
    static float rMax = 2, rStep = 0.25; // Radius of the ball representing stamens and carpels
    static float ratio = 0.3;            // Determines the position of the petal center along the major axis
    static float n = 6;                  // Number of petals
    static float pitch = PI / 2;         // Pitch deviation from the branch that this flower attaches to
}

public class Flower implements Symbol
{
    private float branchR;
    private float l;
    private float w;
    private float r;
    private float roll;
    private float pitch;
    
    public Flower(float branchR, float l, float w, float r, float roll, float pitch)
    {
        this.branchR = branchR;
        this.l = l;
        this.w = w;
        this.r = r;
        this.roll = roll;
        this.pitch = pitch;
    }
    
    public void apply()
    {
        fill(230, 50, 0);
        noStroke();
        
        pushMatrix();
        rotateY(roll);
        rotateX(pitch);
        
        for (int i = 0; i < FlowerConf.n; ++i)
        {
            pushMatrix();
            rotateY(2 * PI * i / FlowerConf.n);
            rotateX(BranchConf.lateralPitch);
            translate(0, -branchR - FlowerConf.ratio * 2 * l, 0);
            drawPiece(l, w, FlowerConf.ratio);
            popMatrix();
        }
        
        fill(230, 230, 0);
        noStroke();
        
        pushMatrix();
        translate(0, -branchR - r, 0);
        sphere(r);
        popMatrix();
        
        popMatrix();
    }

    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps =
            new ArrayList<>(Arrays.asList(new Flower(min(branchR + BranchConf.rStep, BranchConf.rMax),
                                                     min(l + FlowerConf.lStep, FlowerConf.lMax),
                                                     min(w + FlowerConf.wStep, FlowerConf.wMax),
                                                     min(r + FlowerConf.rStep, FlowerConf.rMax),
                                                     roll,
                                                     pitch)));
        return reps;
    }
}

public static class ApexConf
{
    static float rotStep = PI / 3; // Rotation of the apex during each apex growth
    static float pGrow = 0.05;     // Probablity of the appex to grow a main branch
    static float pLeaf = 0.1;      // Probablity of the apex to grow a main branch and a leaf
    static float pFlower = 0.005;  // Probablity of the apex to grow a main branch and a flower
    static float pBranch = 0.03;   // Probablity of the apex to grow a main branch and n lateral branches
    static float scaleRatio = 2.5; // Reduce the probability for apices in lateral branches to grow
}

public class Apex implements Symbol
{
    private float branchR;
    private float rot;
    private float scale;
    
    public Apex(float branchR, float rot, float scale)
    {
        this.branchR = branchR;
        this.rot = rot;
        this.scale = scale;
    }
    
    public void apply()
    {
    }
    
    public ArrayList<Symbol> getReplacements()
    {
        ArrayList<Symbol> reps = new ArrayList<>();

        float rand = random(1) * scale;
        if (rand < ApexConf.pGrow)
        {
            reps.add(new Branch(BranchConf.mainRatio * branchR, 0, 0, 0));
            reps.add(new Apex(branchR + BranchConf.rStep, rot + ApexConf.rotStep, scale));
        }
        else if (rand < ApexConf.pGrow + ApexConf.pLeaf)
        {
            reps.add(new Branch(BranchConf.mainRatio * branchR, 0, 0, 0));
            reps.add(new Leaf(branchR, 0, 0, rot, LeafConf.pitch));
            reps.add(new Apex(branchR + BranchConf.rStep, rot + ApexConf.rotStep, scale));
        }
        else if (rand < ApexConf.pGrow + ApexConf.pLeaf + ApexConf.pFlower)
        {
            reps.add(new Branch(BranchConf.mainRatio * branchR, 0, 0, 0));
            reps.add(new Flower(branchR, 0, 0, 0, rot, FlowerConf.pitch));
            reps.add(new Apex(branchR + BranchConf.rStep, rot + ApexConf.rotStep, scale));
        }
        else if (rand < ApexConf.pGrow + ApexConf.pLeaf + ApexConf.pFlower + ApexConf.pBranch)
        {
            reps.add(new Branch(BranchConf.mainRatio * branchR, 0, 0, 0));
            for (int i = 0; i < BranchConf.n; ++i)
            {
                float nBR = BranchConf.lateralRatio * branchR;
                reps.add(new LeftParen());
                reps.add(new Branch(nBR, 0, rot + 2 * PI * i / BranchConf.n, BranchConf.lateralPitch));
                reps.add(new Apex(nBR, 1, scale * ApexConf.scaleRatio));
                reps.add(new RightParen());
            }
            reps.add(new Apex(branchR + BranchConf.rStep, rot + ApexConf.rotStep, scale));
        }
        else
        {
            reps.add(new Apex(branchR + BranchConf.rStep, rot, scale));
        }
        return reps;
    }
}

ArrayList<Symbol> symbols = new ArrayList<>(Arrays.asList(new Branch(0, 0, 0, 0), new Apex(0, 0, 1), new LeftParen(), new RightParen()));

void applyAll()
{
    pushMatrix();
    for (Symbol s : symbols)
    {
        s.apply();
    }
    popMatrix();
}

void replaceAll()
{
    ArrayList<Symbol> tmp = new ArrayList<>();
    for (Symbol s : symbols)
    {
        tmp.addAll(s.getReplacements());
    }
    symbols = tmp;
}

void setup()
{
    size(1024, 1024, P3D);
    frameRate(24);
}

void draw()
{   
    background(0);
    
    pushMatrix(); 
    translate(width / 2, 7 * height / 8, 0);
    
    // Rotate the coordinate space with mouse
    if (mousePressed)
    {
        rotateY(map(mouseX, 0, width, -PI / 2, PI / 2));
        rotateX(map(mouseY, 0, height, PI / 2, -PI / 2));
    }
    
    applyAll();
    
    popMatrix();
    
    if (frameCount < 240 || (keyPressed && keyCode == TAB)) replaceAll();
}

void keyPressed()
{
    // Take a screenshot
    if (keyCode == ENTER) saveFrame("screen-####.png");
}
