# Programming Contest Club Poster

## Concept

### Brief

This is a poster which my club (DKU Programming Contest Club) could use during a Club Expo. Our club's mission is to take part in programming contests. Therefore, the poster should convey a geeky impression, but also not without a sense of humor. The poster may be both stuck to the walls and handed out, so the aspect ratio for an A series paper in portrait orientation is chosen.

### Text Element

The text element uses a "coded text" design, which is basically an if statement in C-style code saying that "if you are an elite hacker, you should join the Programming Contest Club." It also references the "leetspeak" trope with "1337 h@ck3r" standing for "elite hacker." The code highlighting and the extra large "Programming Contest Club" requires manual adjustments to its color and placement. The font I chose is Brass Mono, which is a "retro monospaced font inspired by 70's electrical and mechanical design," and a "solid choice for writing code." Therefore, the choice of this font could give a "programming impression."

### Graphics Element

The most essential feature is that all the graphics are drawn on a hexagonal grid in an abstract fashion similar to a pixel art. The overall layout is inspired by the "two soyjaks pointing" meme, with two persons in the bottom corners of the screen having surprised faces and the person to the right pointing to the center of the poster. This directs the focus to the center of the poster, which is a person sitting in front of the computer screen. (Also note that the "Programming Contest Club" text is directly above it.) The three people featured in this poster represents a typical team in the ICPC programming contest, where three team members have to share one computer. The vibrant Tomorrow color palette (which is also a color palette for code text editors) is used in this poster. The careful placement of different colors is able to give a sense of balance. Gradients and noises are added to provide the finer details.

## Iterations

### Iteration 1

I implemented utilities for working with hexagonal coordinates and drawing basic shapes in a hexagonal grid. A random hexagonal grid and some shapes are drawn for testing. I also used a "pencil" tool (which also shows the current hexagonal coordinate) to draw some sketches for text and graphics placements.

![Iteration 1](/data/dku/mediart_206/week_1/1.png){width=6cm}

### Iteration 2

I implemented a utility for drawing texts with different colors before using it to draw highlighted code texts.

![Iteration 2](/data/dku/mediart_206/week_1/2.png){width=6cm}

## Final result

The coder sitting in front of the computer and the two soyjaks pointing at them is added. I used callback functions passed to the shape functions to produce the gradient and noise details.

![Final result](/data/dku/mediart_206/week_1/final.png){width=15cm}

## References

* Hexagonal grid: https://www.redblobgames.com/grids/hexagons
* Hexagonal coordinate tricks: https://observablehq.com/@jrus/hexround
* Triangle drawing algorithm: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling#old-school-method-line-sweeping
* Brass Mono font: https://github.com/fonsecapeter/brass_mono
* Tomorrow theme: https://github.com/chriskempson/tomorrow-theme

# Wavy Illusion Field

## Concept statement

This project aims at recreating and experimenting with an optical motion illusion work named "Primrose's field," which consists of a checkerboard with cross-like shapes of alternating colors placed at the corners of the cells. When looking at Primrose's field, the straight and perpendicular lines appear wavy, and that the illusory motion of the waves could be observed when looking at the different regions of the image.

I will first create a grid of large squares and place the small squares at the corners of the large squares. Then I will manipulate the size, color pattern, and the shape of the small squares to see how will they contribute to the optical illusion and whether I can do better than the original pattern.

## Generative rule

1. A simple checkerboard pattern is drawn in the background with alternating light gray and dark gray patterns.
2. At the corners of the cells in the checkerboard pattern, either a small white square or or a black square could be drawn according to some rules. The "squares" could also be stylized into shapes such as crosses.
3. The pattern could be colorized if needed.

## Design iterations

### Iteration 1

I filled the large squares with light gray and dark gray checkerboard patterns. The small squares are of the same pattern but filled with white and black instead. Then I produced four images with different sizes/shapes for the small squares: large squares, medium squares, small squares, and crosses formed by quadratic curves. From my perspective, no optical illusion is observed with the large square patterns. For the medium and small squares, there is a sight illusion that the lines are slanted instead of being perfectly perpendicular to each other. However, this illusion is most strongly observed with the cross-shaped corners, which hint at the fact that the shape of the cross in the original design might be beneficial in inducing optical illusions.

![Iteration 1.1](/data/dku/mediart_206/week_2/1_1.png){width=4cm}
![Iteration 1.2](/data/dku/mediart_206/week_2/1_2.png){width=4cm}
![Iteration 1.3](/data/dku/mediart_206/week_2/1_3.png){width=4cm}
![Iteration 1.4](/data/dku/mediart_206/week_2/1_4.png){width=4cm}

### Iteration 2

I decided to keep the large checkerboard pattern unchanged, but change the small squares to the following pattern shifted to the right every time you go one row down the board:

```
BBBWW BBBWW ...
 BBBWW BBBWW ...
  BBBWW BBBWW ...
...
```

This pattern aims at recreating the alternating diagonal lines in the original Primrose's field and analyze its contribution to the overall illusory effect. There appears to be a wavy pattern in the medium and the small squares version, and this wavy illusion is further amplified in the pattern with cross-shaped corners. Nevertheless, the illusory effect is still weaker than the original Primrose's field and little to no motion could be observed when focusing the eyes at different regions of the image.

![Iteration 2.1](/data/dku/mediart_206/week_2/2_1.png){width=4cm}
![Iteration 2.2](/data/dku/mediart_206/week_2/2_2.png){width=4cm}
![Iteration 2.3](/data/dku/mediart_206/week_2/2_3.png){width=4cm}
![Iteration 2.4](/data/dku/mediart_206/week_2/2_4.png){width=4cm}

### Iteration 3

I will now use the original Primrose's field patterns:

```
WBBW BWWB WBBW BWWB ...
 WBBW BWWB WBBW BWWB ...
  WBBW BWWB WBBW BWWB ...
...
```

The wavy lines illusion could be also observed in the medium and the small squares version, with the small squares version having the stronger illusion. The motion illusion can now be observed slightly in the small squares version. As is before, the crosses version have the strongest overall illusory effect, pretty much replicating the effect observed in the original Primrose's field.

![Iteration 3.1](/data/dku/mediart_206/week_2/3_1.png){width=4cm}
![Iteration 3.2](/data/dku/mediart_206/week_2/3_2.png){width=4cm}
![Iteration 3.3](/data/dku/mediart_206/week_2/3_3.png){width=4cm}
![Iteration 3.4](/data/dku/mediart_206/week_2/3_4.png){width=4cm}

### Iteration 4

I now shift each row down to the right by two positions:

```
WBBW BWWB WBBW BWWB ...
12WBBW BWWB WBBW BWWB ...
```

This sort of reflects the diagonals vertically, but also looks a bit differently from an actual reflection.

![Iteration 4.2](/data/dku/mediart_206/week_2/4_2.png){width=4cm}

Shifting to the right by three positions doesn't look very interesting:

![Iteration 4.3](/data/dku/mediart_206/week_2/4_3.png){width=4cm}

Shifting to the right by four positions creates an interesting "funnel" pattern that sort of looks like this:

```
\/\/\/
```

![Iteration 4.4](/data/dku/mediart_206/week_2/4_4.png){width=4cm}

Shifting to the right by five, six, and seven positions are just shifting to the left by three, two, and one positions.

![Iteration 4.5](/data/dku/mediart_206/week_2/4_5.png){width=4cm}
![Iteration 4.6](/data/dku/mediart_206/week_2/4_6.png){width=4cm}
![Iteration 4.7](/data/dku/mediart_206/week_2/4_7.png){width=4cm}

### Iteration 5

This is the Primrose's field on a 33x33 grid:

![Iteration 5.1](/data/dku/mediart_206/week_2/5_1.png){width=4cm}

Now, instead of the original Primrose's field pattern, I thought that the Thue–Morse sequence is quite similar to it, which looks like this:

```
W
W B
WB BW
WBBW BWWB
WBBWBWWB BWWBWBBW
```

This sequence could be constructed recursively by appending the inverse of itself to itself repeatedly, or by calculating the parity of the binary representation of the indices. It could be observed that the Thue-Morse sequence of length 8 is the same as the original pattern.

I chose to fill the first row with the Thue-Morse sequence and repeatedly shift it to the right by one when going down the rows. This creates the pattern below, which doesn't look very different from the original design at a glance, and the strength of the illusory effect is approximately the same:

![Iteration 5.2](/data/dku/mediart_206/week_2/5_2.png){width=4cm}

### Iteration 6

I also tried to fill the small squares with white and black randomly, which creates a rather random distortion.

![Iteration 6](/data/dku/mediart_206/week_2/6.png){width=4cm}

## Final results

I took the Thue-Morse sequence pattern from iteration 5 and colorized it. I also animated this pattern by shifting it to right repeatedly every few frames, but this doesn't appear to have a significant impact on the optical illusions effect.

![Final](/data/dku/mediart_206/week_2/final.png){width=15cm}

## References

Akiyoshi's illusion pages: https://www.ritsumei.ac.jp/~akitaoka/index-e.html  
Thue–Morse sequence: https://en.wikipedia.org/wiki/Thue%E2%80%93Morse_sequence  
Color palette: https://colorhunt.co/palette/29000187431dc87941dbcbbd

# Recursive Reconstruction of Images

## Concept

This project is based on the wave function collapse algorithm, which places tiles onto a grid according to certain rules such as whether tile A can be placed to the left of tile B. It optimizes this process by placing a tile on the position with the least entropy each time. The entropy of a position is decided by how many different types of tile could potentially be placed at that position (as decided by its neighboring tiles that are already placed). For example, if only one type of tile could be placed at $(x_0, y_0)$, but there could be two types of tile at $(x_1, y_1)$, then $(x_0, y_0)$ has a lower entropy. This, for example, can be used to procedurally generate a image when given a small image. The small image in this case provides both the tiles (chopped-up pieces of the image) and describes the generative rule (what pieces can be placed together in the small image can be placed together in the generated image).

My idea is to tweak the wave function algorithm so that a) the placement of the tiles are not strict, but the way they neighbor each other is similar to the original image and b) I will sample and "reconstruct" the original image iteratively in increasing larger sizes that are powers of 2 (e.g. 1x1, 2x2, 4x4, ...). This is also inspired by the way how procedural textures are created, where layers of noises of various frequencies are added together so that the lower frequency noises form the overall shape, while the higher frequency noises form the details. Put it another way, I would like to create a image that is "similar" to the original in a sense that both the larger chunks and the small pieces in the output image would relate to their neighbors in a way similar to the original image.

Although not intentionally thought of, the way I tweaked the original algorithm could be comparable to glitch art, where technologies are used in ways that deviate from their original designs to introduce glitches. In a similar fashion, I modified the wave function collapse algorithm according an abstract concept of reconstructed a image with progressively larger tiles. The end result also bears similarity to glitch art aesthetically despite the fact that I actually prefer a more smooth looking. The "blocky" output could be explained by that I only consider the average color of a tile instead of how it would connect to its neighbors.

## Generative rule

My project also implements the wave function collapse algorithm which generates a new image from the rules described by the original image, but it deviates from the usual implementation in four aspects:

1. The placement of the tiles do not adhere to strict rules, but the probability of one tile having color A in the generated image is decided only by the probability of a) the overall probability of a tile having color A in the original image and b) the probability of a tile having color A neighboring another tile of color B in the original image when a tile of color B is already placed in the generated image neighboring the given tile. Formally, let the probability to have tile of color A at $(x, y)$ be $p$. Let the probability to randomly select a tile of color A in the original image be $P(A)$. Let the probability for a tile to have color B to the left of a tile of color A be $P(B|A)$, and the same goes for the tile to the right, up, and down of a tile of color A, which are denoted by $P(C|A), P(D|A), P(E|A)$ respectively. Assuming the independence of the joint probability of all the neighboring tiles, $p$ is calculated as follows according to Bayes' theorem:

$$
p = P(A) \frac{P(B|A) P(C|A) P(D|A) P(E|A)}{P(B) P(C) P(D) P(E)}
$$

2. The process of wave function collapse does not always select the position with the least entropy, but the position is selected each time through a weighted random sampling. The weights are the maximum entropy minus the entropy at the current position. This change favors collapsing the positions with a smaller entropy, but avoids the problem of the output being too determined by the initial decision. This problem can be illustrated by an example: Suppose that we always select the position with the least entropy, and that a blue tile is almost always next to a blue tile and a red tile is almost always next to a red tile in the original image. When the initial tile is set to be blue, its neighbors will have the lowest entropies and will be almost always set to blue. This will continue until the image is filled almost entirely by blue.

3. The generated image is of the same dimensions as the original, but the tiles are of progressively larger sizes that are powers of 2 (e.g. 1x1, 2x2, 4x4, ...). For tiles that are larger than 1x1, its color means the average color of its pixels. When placing the tiles, I would first only consider their average colors before finally assign the actual tile randomly from a pool of tiles sharing the same color.

4. The generation process is iterative:

    1. The original image is sampled by 1x1 tiles to calculate the probabilities.
    2. A new image is generated by placing 1x1 tiles of different colors according to the probabilities.
    3. The new image is sliced into 4x4 tiles for the next iteration.
    4. The original image is sampled again by 4x4 tiles, where the average color of each tile will be considered.
    5. A new image is generated by placing the 4x4 tiles generated from the previous iteration.
    6. The process repeats until the desired tile size is reached.

## Design iterations

### Original image

![Original](/data/dku/mediart_206/week_3/peppers.png)

### 1. RGB12

The original image is converted from 24-bit RGB to 12-bit RGB by using only the highest 4 bits for each channel.

![Iteration 1](/data/dku/mediart_206/week_3/1.png)

### 2. Quantization

The most frequently used 16 colors (excluding those that are too similar to each other) are chosen to form a palette, and the pixels from the original image is replaced with the closet colors from the palette.

![Iteration 2](/data/dku/mediart_206/week_3/2.png)

### 3. Tilelify

The utility function for grouping pixels into tiles is implemented. Below is a example of grouping pixels into 4x4 tiles like this:

```
1122
1122
3344
3344
```
The upper-leftmost pixel from each tile is extracted to form the image below:

![Iteration 3](/data/dku/mediart_206/week_3/3.png)

### 4. Wave function collapse by picking the lowest entropy position

In this iteration, I implemented the wave function collapse algorithm by placing a tile on the position with the lowest entropy in each step (see the `peppers_min` folder for more details). This, however, has the problem of the result being too determined by the initial decision as mentioned above.

![Iteration 4](/data/dku/mediart_206/week_3/peppers_min/iter_0.png)

## Final results

A weighted random approach is used to generate the final result to address the problem encountered in iteration 4. In the final implementation, results from the previous iteration is fed into the current iteration to iteratively "refine" the result. (Nevertheless, the outputs of later iterations tend to become more blocky.) I also added a log to record the order that the positions are collapsed, which is later played as a video.

* Images of the outputs from different iterations: original_image_name/iter_#.png
* Video of the wave function collapse algorithm running: original_image_name/collapse.mkv

*Note: If you zoom into the outputs for a closer look, they might look blurry. This is because interpolation is often used to upscale an image.*

### Peppers

#### Original

![Peppers](/data/dku/mediart_206/week_3/peppers.png)

#### Outputs of iterations 0 to 5

![Peppers Iteration 0](/data/dku/mediart_206/week_3/peppers/iter_0.png)
![Peppers Iteration 1](/data/dku/mediart_206/week_3/peppers/iter_1.png)
![Peppers Iteration 2](/data/dku/mediart_206/week_3/peppers/iter_2.png)
![Peppers Iteration 3](/data/dku/mediart_206/week_3/peppers/iter_3.png)
![Peppers Iteration 4](/data/dku/mediart_206/week_3/peppers/iter_4.png)
![Peppers Iteration 5](/data/dku/mediart_206/week_3/peppers/iter_5.png)

### House

#### Original

![House](/data/dku/mediart_206/week_3/house.png)

#### Outputs of iterations 0 to 5

![House Iteration 0](/data/dku/mediart_206/week_3/house/iter_0.png)
![House Iteration 1](/data/dku/mediart_206/week_3/house/iter_1.png)
![House Iteration 2](/data/dku/mediart_206/week_3/house/iter_2.png)
![House Iteration 3](/data/dku/mediart_206/week_3/house/iter_3.png)
![House Iteration 4](/data/dku/mediart_206/week_3/house/iter_4.png)
![House Iteration 5](/data/dku/mediart_206/week_3/house/iter_5.png)

### Mandrill

#### Original

![Mandrill](/data/dku/mediart_206/week_3/mandrill.png)

#### Outputs of iterations 0 to 5

![Mandrill Iteration 0](/data/dku/mediart_206/week_3/mandrill/iter_0.png)
![Mandrill Iteration 1](/data/dku/mediart_206/week_3/mandrill/iter_1.png)
![Mandrill Iteration 2](/data/dku/mediart_206/week_3/mandrill/iter_2.png)
![Mandrill Iteration 3](/data/dku/mediart_206/week_3/mandrill/iter_3.png)
![Mandrill Iteration 4](/data/dku/mediart_206/week_3/mandrill/iter_4.png)
![Mandrill Iteration 5](/data/dku/mediart_206/week_3/mandrill/iter_5.png)

## Dependencies

* This specific fork of Video Export Library: https://github.com/hamoid/video_export_processing/tree/kotlinGradle
* ffmpeg

## References

* Wave function collapse algorithm: https://robertheaton.com/2018/12/17/wavefunction-collapse-algorithm/
* Color quantization: https://stackoverflow.com/questions/29244307/effective-gif-image-color-quantization
* SIPI Image Database - Misc: https://sipi.usc.edu/database/database.php?volume=misc

# Illegible Black Metal Band Logo Generator

## Concept

This project aims at recreating the font for stereotypical unintelligible black metal band logos, which could be characterized by the two following features:

1. Tree-like branches emerging from the base text font.
2. Blood-dripping effect along these branches.

These two features can be observed in the logo of the black metal band Darkthrone given below:

![Darkthrone logo](/data/dku/mediart_206/week_4/darkthrone.jpg){width=4cm}

It should be noted that not all black metal band logos exhibit this style as there are also many bands with clean-looking logos (for example, Emperor). Darkthrone is also not the band with the most unintelligible logo since there are much worse offenders. However, this project simply aims at parodying this "unreadable logo" trope in general.

While these two features could be implemented separately (recursive branching and drawing vertical lines attached to the branches), I took the approach of combining these two features by having the branches bending down gradually like a willow tree.

There are other features that are common in black metal logos. The most prominent is the black and white color, which will be used in this project. Another is the frequent use of Gothic font, which will not be used in this project as I would prefer to draw the base text font on my own using simple strokes and that Gothic fonts are usually used in logos that are clean and engraved-like as opposed to the sprawling tree-like logos that I would generate.

## Generative rule

### Visual object

The visual object is drawn with Agent, which are objects that draw a point (of given stroke) at their current locations and advance their positions every frame. The two types of Agent are:

1. Trunk: Draws the base text font, which contains all the uppercase Latin characters.
2. Branch: Emerges from the base text font to create the branching and blood-dripping effects.

### Parameters

```java
// Scale of the noise xy-coordinates
final float noiseScale = 0.01;

public class Trunk implements Agent
{
    // Maximum time (in frames)
    private static final int   tMax = 300;
    // Stroke weight at beginning and middle
    private static final float swBeg = 15, swMid = 25;
    // Stroke weight interpolation exponent
    private static final float swExp = 1.5;
    // Bezier curve amount at corners
    private static final float smoothAmt = 0.2;
    // Amount of displacement along noise gradient
    private static final float dispScale = 5;
    // Probability to create a new branch
    private static final float branchProb = 0.15;
    // Scale of the branch initial stroke weight
    private static final float branchScale = 1;
    // Minimum and maximum branch length
    private static final float branchLenMin = 150, branchLenMax = 300;
}

public class Branch implements Agent
{
    // Maximum time (in frames)
    private static final int   tMax = 200;
    // Stroke weight interpolation exponent
    private static final float swExp = 0.75;
    // Amount of random gradient added to branch movement
    private static final float randAmt = 0.55;
    // Maximum downward shift
    private static final float yShiftMax = 5;
    // Downward shift interpolation exponent
    private static final float yShiftExp = 3;
    // Maximum branch depth
    private static final int   depthMax = 2;
    // Probability of creating a new branch
    private static final float branchProb = 0.05;
    // Scale of the branch initial stroke weight
    private static final float branchScale = 0.8;
    // Minimum and maximum branch length
    private static final float branchLenMin = 50, branchLenMax = 100;
}
```

### Algorithm

#### Trunk

Each character is defined by a series of strokes, which in turn are line segments connecting a series of points on a 5x5 integer coordinate grid. Below are the two strokes composing an "A" character numbered with 1 and 2:

```
..1..
.1.1.
.222.
1...1
1...1
```

The Trunk Agent linearly interpolates along the sum of all stroke lengths in each frame to render a point from a certain stroke. However, if the current point lies on the corners of a stroke, a Bézier curve would be used to connect the two neighboring line segments smoothly. The stroke weight is also interpolated so that the middle of the stroke has the highest weight while the beginning and the end of the stroke has the lowest. Both the curved corner and the changing stroke weight are for simulating drawing a stroke with a pen.

Displacement is then applied to the points so that they are shifted slightly along the noise gradient, which can be comparable to the jittering of the pen.

Finally there is a random chance every frame that a branch will be created from the current position with the initial stroke weight proportional to the current stroke weight of the Trunk.

#### Branch

The Branch Agent draws a point at its current position and moves forward by a gradient every frame. This gradient is a sum of three vectors:

1. Noise gradient: This can be thought of as extruding the screen along the z-axis to provide a terrain for the branches to "flow" like blood from high to low ground.
2. Random gradient: This allows the branches to grow randomly, providing a tree-like texture.
3. Y-shift: This bends the branches downward gradually. The more the branches extend, the more they will move downward along the Y-axis.

Combining these three vectors gives a mix between tree the tree-branching and blood-dripping effects.

There is also a chance for a branch to recursively create a subbranch every frame, limited by the maximum branch depth.

## Design iterations

### Iteration 1

Lines are drawn along the strokes to compose the characters.

![Iteration 1](/data/dku/mediart_206/week_4/1.png){width=4cm}

### Iteration 2

Stroke weight is linearly interpolated along each stroke.

![Iteration 2](/data/dku/mediart_206/week_4/2.png){width=4cm}

### Iteration 3

Bézier curve is used to smooth out the corners connecting the line segments.

![Iteration 3](/data/dku/mediart_206/week_4/3.png){width=4cm}

### Iteration 4

Trunk object is added. Base text font drawing code is rewritten so that the process of drawing is animated.

![Iteration 4](/data/dku/mediart_206/week_4/4.png){width=4cm}

### Iteration 5

Branch object is added. Branches are created randomly from the base text font toward random directions.

![Iteration 5](/data/dku/mediart_206/week_4/5.png){width=4cm}

### Iteration 6

A 2D noise height map is added and that the gradient at each point is calculated with finite difference. The gradient field is then drawn on the background similar to a normal map with color red for the X component and green for Y component. The branches now move along the gradient field and that a "flowing" texture can be observed.

Stroke weight interpolation is changed to have the thickest part in the middle.

![Iteration 6](/data/dku/mediart_206/week_4/6.png){width=4cm}

### Iteration 7

Random gradient and downward Y-shift are added to Branch so that the branches can have more of the "willow tree" appearance.

Noise gradient displacement is added to the base text font so the text also appears jittered.

Noise scale is adjusted and that the noise is made symmetrical so that it may produce a more symmetrical band logo theoretically (which unfortunately does not appear to work for the alphabet).

![Iteration 7](/data/dku/mediart_206/week_4/7.png){width=4cm}

### Iteration 8

Recursive branching is added.

![Iteration 8](/data/dku/mediart_206/week_4/8.png){width=4cm}

## Final results

### "Default" parameters

This is drawn using the parameters that look the most "correct" to me. (See "Generative rule: Parameters" for the exact parameters.)

![Final default](/data/dku/mediart_206/week_4/final_default.png){width=15cm}

### Thin beginning and end, fat middle stroke

The following parameters are changed:

```java
// Stroke weight at beginning and middle
private static final float swBeg = 5, swMid = 50;
```

![Final thin/fat](/data/dku/mediart_206/week_4/final_thin_fat.png){width=15cm}

### "Convex" branch stroke weight function

The branch stroke weight shrinks increasingly faster:

```java
// Stroke weight interpolation exponent
private static final float swExp = 3;
```

![Final convex branch](/data/dku/mediart_206/week_4/final_convex_branch.png){width=15cm}

### More fluid-like branches

The amount of random gradient is reduced:

```java
// Amount of random gradient added to branch movement
private static final float randAmt = 0.3;
```

![Final fluid branch](/data/dku/mediart_206/week_4/final_fluid_branch.png){width=15cm}

### "Furry" branches

Recursive branching depth is increased:

```java
// Minimum and maximum branch length
private static final float branchLenMin = 200, branchLenMax = 400;
// Maximum branch depth
private static final int   depthMax = 3;
// Probability of creating a new branch
private static final float branchProb = 0.02;
// Minimum and maximum branch length
private static final float branchLenMin = 100, branchLenMax = 200;
```

![Final furry branch](/data/dku/mediart_206/week_4/final_furry_branch.png){width=15cm}

## References

* Darkthrone logo: https://sk.pinterest.com/pin/426434658442686417
* Extruding a font along a field: https://openprocessing.org/sketch/1989053
* Bézier curve: https://en.wikipedia.org/wiki/B%C3%A9zier_curve

# Chinese income visualization

## Concept

I want to explore the relationship among income, industry, and working hours. As a multitude of relationships would be considered, and that there are many categories of industries (about twenty), I would produce three graphs about this topic:

1. The distribution of income in different industry categories with a histogram for each industry category.
2. The number of workers in different industries at different income levels and how some industry might have more workers than the others at different income levels. As there are numerous industry categories, the four broad divisions of industrial sectors would be used instead. The graph would be a hybrid between stacked bar chart and bump chart.
3. A scatter plot showing how working hours correlates with income level. This could demonstrate the current unfair situation of "more work, less pay."

The purpose of this project is to investigate how the income inequality of Chinese waged workers is related to the industries that they work in. On the left is a histogram representing the wage distribution within each industry. On the top is a stacked bar chart/bump chart hybrid representing the number of surveyed workers in each industrial sector at each income range. It can be observed that very few people work in the primary sector and that they usually have very low wages. People working in finance, technical service, and IT tend to have the highest wages. However, tertiary sector constitutes the majority of low income workers, while secondary sector makes up most of the medium to high income workers.

## Generative rule

### Dataset

Source: CFPS (China Family Panel Studies) 2018 survey

As the original data is very wide - surveying many aspects concerning the individuals and families in China, I picked out only the most relevant columns concerning the industry, occupation, weekly working hours, and yearly income of waged laborers.

### Income distribution by industry histogram

#### Visualization strategy

* Density vs. __lightness__: To make the graph easier to read, I opt for a higher data-ink ratio and use spacing instead of explicit grid lines to line up the bars with data values.
* __Function__ vs. decoration: I want this graph to be a straightforward visualization. Therefore, the elements shown are just the data and labels without decorations.
* __Abstraction__ vs. figuration: The data is displayed as bars as opposed to fancier visual elements.
* __Familiarity__ vs. originality: The simple histogram is a very traditional choice of data visualization.
* Redundancy vs. __novelty__: Each data point is only shown once. The income label is drawn twice though, as the chart is very tall.
* __Multi-dimensional__ vs. uni-dimensional: Income is not only categorized by industries, but the distribution of the workers a certain income is also shown within each industry.

#### Mapping method

The data points would be grouped by the twenty industry categories. Then for each category, a histogram showing the distribution of workers of different income levels would be drawn. Note that these histograms would be proportional to the workers within that industry instead of all the waged workers surveyed, and there is a great disparity of worker numbers among different industries.

#### Objective

I would like to demonstrate how the income level of workers are distributed differently among different industries and the general tendency of income levels concentrating around a certain (and rather low) level. Still, the overall presentation would be informative and neutral.

### Number of workers by income and sector bump chart

#### Visualization strategy

* Density vs. __lightness__: The graph has no grid and extra annotations as the focus is on the relative values of the data points instead of the exact values.
* __Function__ vs. decoration: The graph displays data directly without much decoration.
* __Abstraction__ vs. figuration: Data points are shown as abstract bars.
* Familiarity vs. __originality__: A combination of stacked bar chart and bump chart would be employed, which is a very original design.
* __Redundancy__ vs. novelty: Parts of the graph is duplicated in a larger scale as some bars are too short to be shown clearly.
* __Multi-dimensional__ vs. uni-dimensional: The sectors, income levels, the number of the workers, and their ranks are all shown in the same graph.

#### Mapping method

The data would be binned according to the income levels first. Within each bin, the number of workers in the four industrial sectors are counted respectively and that the four sectors are then ranked. The bins are then represented with bars that are further divided into four bars representing the four sectors. The sub-bars representing the same sector in the adjacent bars are then connected to form a hybrid between bar chart and bump chart.

#### Objective

The main objective is to show the distribution of workers and the inequality of wages among different industries. The overall presentation style would be informative and neutral.

### Working hours vs. income

#### Visualization strategy

* Density vs. __lightness__: The graph focuses on the general trend between working hours and income instead of the specific values.
* __Function__ vs. decoration: The graph displays data directly without much decoration.
* __Abstraction__ vs. figuration: Data points are just points in the scatter plot as there are many data points.
* __Familiarity__ vs. originality: The standard design of a scatter plot with a best fitting line is used.
* Redundancy vs. __novelty__: The information is present without duplicates.
* Multi-dimensional vs. __uni-dimensional__: Only the relationship between income and working hours is considered.

#### Mapping method

A scatter plot would be used to plot each worker as a circle according to their income and working hours. The circles plotted would be transparent to show their density. A best fitting line calculated through linear regression would be then drawn over it.

#### Objective

This graph aims to highlight the issue of people with higher income tending to working less and that a significant portion of people with low income working extremely long hours. The color scheme of black, white, and red is chosen to provide a sharp contrast and for their historical connection with labor rights and workers' revolution.

## Design iterations

The most relevant columns are extracted from the original dataset using Python Pandas. Some basic analysis and visualization is than performed using Pandas and Matplotlib to determine the topics of interest.

### Income distribution by industry histogram

#### Iteration 1

Simple histograms for income distribution are plotted for each industry.

![Iteration 1](/data/dku/mediart_206/week_5/income_hist/1.png){width=4cm}

#### Iteration 2

A color palette is chosen for the histograms. I specified the spacing and layout for the graph to leave room for title and labels.

![Iteration 2](/data/dku/mediart_206/week_5/income_hist/2.png){width=4cm}

#### Iteration 3

Title and XY-axis labels are added. Vertical ticks that have the same color as the background are drawn to indicate income number. The annotation on the right shows that proportion of the workers represented by a full-length bar.

![Iteration 3](/data/dku/mediart_206/week_5/income_hist/3.png){width=4cm}

#### Iteration 4

The industries are now sorted ascending by mean income. More comments are added.

![Iteration 4](/data/dku/mediart_206/week_5/income_hist/4.png){width=4cm}

### Number of workers by income and sector bump chart

#### Iteration 1

Spacing and layout for the graph is outlined.

![Iteration 1](/data/dku/mediart_206/week_5/income_bump/1.png){width=4cm}

#### Iteration 2

A stacked bar graph is drawn. The sub-bars in every bar is sorted by its length. The right half of the graph is magnified.

![Iteration 2](/data/dku/mediart_206/week_5/income_bump/2.png){width=4cm}

#### Iteration 3

The bars from the same sector is connected in a fashion similar to a bump chart.

![Iteration 3](/data/dku/mediart_206/week_5/income_bump/3.png){width=4cm}

#### Iteration 4

The connections are smoothed with quadratic Bézier curves.

![Iteration 4](/data/dku/mediart_206/week_5/income_bump/4.png){width=4cm}

#### Iteration 5

Title and labels are added.

![Iteration 5](/data/dku/mediart_206/week_5/income_bump/5.png){width=4cm}

### Working hours vs. income

#### Iteration 1

X- and Y-axis ticks are drawn.

![Iteration 1](/data/dku/mediart_206/week_5/income_hours/1.png){width=4cm}

#### Iteration 2

A scatter plot is created by drawing transparent circles.

![Iteration 2](/data/dku/mediart_206/week_5/income_hours/2.png){width=4cm}

#### Iteration 3

Title and axis labels are added.

![Iteration 3](/data/dku/mediart_206/week_5/income_hours/3.png){width=4cm}

#### Iteration 4

The best fitting line is found through linear regression.

![Iteration 4](/data/dku/mediart_206/week_5/income_hours/4.png){width=4cm}

## Final results

![Iteration 4](/data/dku/mediart_206/week_5/income_hist/4.png){width=10cm}

![Iteration 5](/data/dku/mediart_206/week_5/income_bump/5.png){width=15cm}

![Iteration 4](/data/dku/mediart_206/week_5/income_hours/4.png){width=15cm}

## References

CFPS: https://www.isss.pku.edu.cn/cfps/en/data/public/index.htm  
Color picker: https://tristen.ca/hcl-picker  
ChatGPT: Some code for data exploration and the code for linear regression

# Game: Infernoxene

## Concept statement

This is a 2D pixel side-scrolling action puzzle game where you burn all the enemies to death by utilizing flammable oil and other objects on the map. It includes a mix of rigid body and falling sand physics to provide a physics-based immersive gameplay experience.

## Generative rules

### Inspiration

The real-life inspired aspect of this game is basically the amount of ways that you can tackle a problem (or, more specifically, kill someone) in real life compared to, for example, in an FPS game where you can only shoot the enemies to death. This game chose to specifically focus on the aspect of fire propagation and physics and how they could be used as weapons to deal with the enemies.

The video game inspirations is most directly Noita, a game where every pixel is simulated. There are also inspirations from games like Dark Messiah of Might and Magic and Half-life 2 where physics play an important role. The lethality of fire in Far Cry 2 is also an inspiration.

### Gameplay

#### Starting point

You play as a character who can move up, down, left, and right in a given map. You can grab and throw objects and also cast sparks to light up flammable substances.

#### Objectives

Burn all the enemies to death while not getting caught up in the flames yourself.

#### Rules

Both the player and the enemy can move left and right, jump and "fast fall". Touching burning substance decreases both the player and the enemy's health. Both the player and the enemy die when they run out of the health.

The rigid bodies in the game world obey conservation of momentum except when external forces are applied. They could crash into each other and are under the influence of gravity and friction. The fluids are simulated through falling sand cellular automata rules (which doesn't fully obey rules in the real world). Fire is ignited by spark and are propagated through flammable substances.

### Core mechanics and loop

Player move push and throw objects around and cast oil bottles to create a way to set enemies on fire. They can cast a spark to set oil on fire to damage the enemies while avoid receiving damage themselves. Simultaneously, objects can also be used as obstacles for the player to defend themself from fire damage or to obstruct the enemies from throwing objects.

### Anticipated player experience

Players would be thrilled in the brutal termination of the enemies while engaging in the intellectual problem-solving process of making the best of what they have on the map and to utilize the physics to conduct this process creatively.

## Iterative process

### Iteration 1

I begin by implementing a basic falling sand simulation for water. This is done through simple cellular automata rules where each water pixel could move downward (including diagonally downward) and sideways during each simulation frame.

![Iteration 1](/data/dku/mediart_206/week_6/it/1.png){width=10cm}

### Iteration 2

A fail attempt at simulating every pixel with Brownian motion, surface tension, and pressure. I thought up some ungrounded ways to simulate these rules, which did not work well. Therefore, I went back to the basic approach afterwards.

![Iteration 2](/data/dku/mediart_206/week_6/it/2.png){width=10cm}

### Iteration 3

Add oil into the fluid simulation. It can also interact with water by having each oil pixel moving up when contacting with water. Note that in the final game I did not include water at all as my time have ran out, but there are potential ways in which oil-water interaction could be implemented.

![Iteration 3](/data/dku/mediart_206/week_6/it/3.png){width=10cm}

### Iteration 4

Add rigid bodies that cannot move yet. They will however interact with liquids by displacing all the pixels that share the same space.

![Iteration 4](/data/dku/mediart_206/week_6/it/4.png){width=10cm}

### Iteration 5

Add collision detection and resolution concerning rigid bodies and the map border. More details are explained below.

![Iteration 5](/data/dku/mediart_206/week_6/it/5.png){width=10cm}

### Iteration 6

Add collision between rigid bodies. Each rigid body is modeled as connected squares, but the edges of a rigid body have the shape a series of circles. This could be understood as this:
```
oooo
o##o
o##o
oooo
```
For a rigid body of square shape.

The collision between rigid bodies are then resolved using a hand-made sequential impulse solver.

![Iteration 6](/data/dku/mediart_206/week_6/it/6.png){width=10cm}

### Iteration 7

Add textured sprites. I have used the components pattern from Game Programming Patterns to organize each game object, where each GameObject class would be consisted of a Sprite, a Input, a Logic, and a body.

![Iteration 7](/data/dku/mediart_206/week_6/it/7.png){width=10cm}

### Iteration 8

Add controllable player.

![Iteration 8](/data/dku/mediart_206/week_6/it/8.png){width=10cm}

### Iteration 9

Add oil bottles that break on hard impact and release oil.

![Iteration 9](/data/dku/mediart_206/week_6/it/9.png){width=10cm}

### Iteration 10

Add enemies that move around randomly. Oil can now be ignited with sparks and that fire will spread within oil. Player and enemy will die instantly upon contact with burning oil.

![Iteration 10](/data/dku/mediart_206/week_6/it/10.png){width=10cm}

### Iteration 11

Add health bar and that contact with burning oil is not a one-hit kill anymore, but will decrease the health of the agent that comes into contact with it proportionally.

![Iteration 11](/data/dku/mediart_206/week_6/it/11.png){width=10cm}

### Iteration 12

The ability to throw objects and cast spark are implemented.

![Iteration 12](/data/dku/mediart_206/week_6/it/12.png){width=10cm}

### Iteration 13

A actual level editor is implemented. You may preview objects in the level editor. Level loading and saving are also implemented through manual serialization of GameObject.

![Iteration 13](/data/dku/mediart_206/week_6/it/13.png){width=10cm}

### Iteration 14

Add decorative and solid pixels in falling sand simulation. Add plank object.

![Iteration 14](/data/dku/mediart_206/week_6/it/14.png){width=10cm}

### Iteration 15

Add level exit at the right side of the screen where you may exit the level by entering it while all enemies are dead.

![Iteration 15](/data/dku/mediart_206/week_6/it/15.png){width=10cm}

### Iteration 16

Add sentry, which is a type of enemy that stays still and cast oil bottle and spark alternatively continously.

![Iteration 16](/data/dku/mediart_206/week_6/it/16.png){width=10cm}

## Final result

### Level 0

Title screen and introduction to basic movement.

![Level 0](/data/dku/mediart_206/week_6/fin/0.png){width=10cm}

### Level 1

Introduction to the spark casting and fire propagation mechanics. The player must use spark to ignite the oil pool and burn all the enemies to death.

![Level 1](/data/dku/mediart_206/week_6/fin/1.png){width=10cm}

### Level 2

Introduction to how the velocity of the spark projectile is relative to your movement velocity.

![Level 2](/data/dku/mediart_206/week_6/fin/2.png){width=10cm}

### Level 3

This level requires the player to run, jump, and cast spark.

![Level 3](/data/dku/mediart_206/week_6/fin/3.png){width=10cm}

### Level 4

This level introduces the grabbing mechanic and how you can push objects.

![Level 4](/data/dku/mediart_206/week_6/fin/4.png){width=10cm}

### Level 5

This level introduces how a rigid body blocks the flow of liquid.

![Level 5](/data/dku/mediart_206/week_6/fin/5.png){width=10cm}

### Level 6

It demonstrates how oil bottle works: How you can throw it and how it shatters on impact.

![Level 6](/data/dku/mediart_206/week_6/fin/6.png){width=10cm}

### Level 7

This level further tests the players ability to utilize bottle throwing, spark casting, and other mechanics previously introduced.

![Level 7](/data/dku/mediart_206/week_6/fin/7.png){width=10cm}

### Level 8

This level shows how you can make a ramp using a tilted plank.

![Level 8](/data/dku/mediart_206/week_6/fin/8.png){width=10cm}

### Level 9

This level demonstrates how you can remove the boxes to retrieve the bottles before using them as weapons.

![Level 9](/data/dku/mediart_206/week_6/fin/9.png){width=10cm}

### Level 10

Introduction to the sentry enemy type.

![Level 10](/data/dku/mediart_206/week_6/fin/10.png){width=10cm}

### Level 11

The player is challenged to defeating the sentry using oil bottles.

![Level 11](/data/dku/mediart_206/week_6/fin/11.png){width=10cm}

### Level 12

The player could try blocking the flow of sentry's oil to have it burn itself to death.

![Level 12](/data/dku/mediart_206/week_6/fin/12.png){width=10cm}

### Level 13

A very difficult challenge where the player has to face two sentries simultaneously while the burning oil builds up.

![Level 13](/data/dku/mediart_206/week_6/fin/13.png){width=10cm}

### Level 14

This level demonstrates that the player can hold on to the plank to escape the burning oil.

![Level 14](/data/dku/mediart_206/week_6/fin/14.png){width=10cm}

### Level 15

A randomly arranged final level.

![Level 15](/data/dku/mediart_206/week_6/fin/15.png){width=10cm}

## Controls

* P: Restart
* \` (The key above tab): Toggle playing/editor
* Enter: Screenshot

### Playing

* WASD: Movement
* Left mouse button: Grab
* Right mouse button: Cast spark
* Drag mouse: Move arm

### Editor

* Select the object to place:  
    1: Solid  
    2: Oil  
    3: Box  
    4: Plank  
    5: Oil bottle  
    6: Spark  
    7: Player  
    8: Enemy  
    9: Sentry  
    0: Decoration
* Backspace: Deletion tool for falling sand
* Tab: Save level
* Left/right arrow: Previous/next level

## Notes

* Do try the editor mode to play it like a sandbox or to skip levels!
* The written from scratch physics engine is really clunky...

## References

* https://www.youtube.com/watch?v=prXuyMCgbTc
* https://gameprogrammingpatterns.com
* https://www.cs.ubc.ca/~rhodin/2020_2021_CPSC_427/lectures/D_CollisionTutorial.pdf
* https://box2d.org/files/ErinCatto_SequentialImpulses_GDC2006.pdf

# Abstract 3D Plant Based on L-system (Extra Credit for Week 6)

## Concept

The main goal of this project is to create a basic semi-realistic model of plants with L-system. L-system represents a plant with a string where each character is a component. This string is then drawn in a fashion similar to turtle graphics. The plant is "grown" by replacing the characters in the string according to certain rules that are modeled after the real-life cell division and elongation events that occur during plant growth.

## Generative rule

L-system is a parallel rewriting system where a string representing the components are replaced simultaneously in each iteration according to certain rules. The string of components will be read from left to right and drawn. An imaginary "cursor" would represent the origin and the orientation for the current component to be drawn, which would also be updated after drawing the current component. Parentheses are used to store the cursor states on a stack to allow drawing branches. The components of this L-system would be the branches, leaves, flowers, and the apices where the new branches, leaves, and flowers are created (due to them being the places where cell divisions occur).

In this project, the process of planet growth will be animated. Therefore, rewriting will occur each frame where the new components are created from apices and that the existing components will also grow accordingly (cell elongation). The rules for rewriting will be stochastic, so that a apex might be replaced by different components probabilistically in each iteration.

The branches, leaves, and flowers are abstract shapes in this project. The configuration (for example, how many branches the apex might create each time) and the rewriting rules are static. Randomizing these rules and adding more details like branch textures are wind animations could be a project for the future.

### Vocabulary and rules

* A: apex
* B: branch
* L: leaf
* F: flower

The following replacements will happen probabilistically in each iteration:

* A -> BA
* A -> BLA
* A -> BFA
* A -> B(BA)(BA)...(BA)A

The existing components will also grow in size if possible.

## Iterative process

### Iteration 1

Implementing the utilities for drawing a branch and rotating the coordinate space with mouse

![Iteration 1](/data/dku/mediart_206/week_6_extra/1.png){width=10cm}

### Iteration 2

A basic L-system with only rough prototypes of branches and leaves. It is unrealistic as branching does not happen only in apices.

![Iteration 2](/data/dku/mediart_206/week_6_extra/2.png){width=10cm}

### Iteration 3

Relatively more detailed flowers and leaves are added. Leaves and petals are drawn as triangle fans fitted to unevenly squashed circles. Branching now only occurs at apices.

![Iteration 3](/data/dku/mediart_206/week_6_extra/3.png){width=10cm}

## Final result

Configurations are tweaked slightly for the plant growth animation. Lateral branches now grow more slowly just like real plants (though this also reduces the computational workload).

![Final 1](/data/dku/mediart_206/week_6_extra/three branches){width=10cm}
![Final 2](/data/dku/mediart_206/week_6_extra/two branches){width=10cm}
![Final 3](/data/dku/mediart_206/week_6_extra/four branches){width=10cm}

## References

L-system: Prusinkiewicz, P., & Lindenmayer, A. (2012). _The algorithmic beauty of plants_. Springer Science & Business Media.  
Cylinder drawing: https://vormplus.be/full-articles/drawing-a-cylinder-with-processing
