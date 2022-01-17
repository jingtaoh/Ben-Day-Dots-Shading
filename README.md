# Ben-Day-Dots-Shading

## Introduction

I came across a series of great articles written by [Legion of Andy](https://legionofandy.com/) describing the history of [Ben Day Dots](https://en.wikipedia.org/wiki/Ben_Day_process), where they were used as a cheap and efficient way to print colors in the newspapers and comic books in the 20th century. So I decided to program it to achieve the same effect over the weekend.

|<img src="https://legionofandy.files.wordpress.com/2016/08/panel-screener.jpg" alt="Prince Valiant" width="600">|
|:---:|
|*(Image credit: © [Legion of Andy](https://legionofandy.com/))*|

The following diagram is an [experiment](https://legionofandy.com/2016/08/26/ben-day-dots-part-8-1930s-to-1950s-the-golden-age-of-comics/) introduced in Andy's blog (thank you, Andy)! In the old-time, artists will need to prepare 4 versions of the painting in order to print them, one color for each version, i.e. yellow, magenta, cyan, and black. If we print them into the paper in order, we will get a multi-color painting. The first row is what each version looks like, the second column shows the progressive result that we would expect.

|  | Yellow | Magenta | Cyan | Black | Paper texture |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Separated | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta.png) | ![cyan single pass](images/super-man/cyan.png) | ![black single pass](images/super-man/black.png) | ![After](images/paper.png) |
| Progressive | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta-p.png) | ![cyan single pass](images/super-man/cyan-p.png) | ![black single pass](images/super-man/black-p.png) | ![After](images/super-man/blend-paper.png) |

With only 4 colors (cyan, magenta, yellow, and black, [CMYK](https://en.wikipedia.org/wiki/CMYK_color_model) for short), we can only achieve a total of 7 colors (3 primary colors, 3 secondaries, and black).

|<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/CMYK_subtractive_color_mixing.svg/1920px-CMYK_subtractive_color_mixing.svg.png" alt="CMYK" width="200">|
|:---:|
|*(Image credit: © [Wikipedia](https://en.wikipedia.org/wiki/CMYK_color_model))*|

Here is where the magic of Ben Day Dots comes in, by printing patterns of various sizes and spacings of dots, artists can control the shade of the color, thus creating more variation of shade. Later I will create the light color (about 25%) with dots, dark color (about 50%) with lines, and solid color (100%) for each primary color.


| <img src="https://legionofandy.files.wordpress.com/2015/07/ben-day-patterns-dalgin-p-21-72dpi.jpg" alt="CMYK" width="600"> |<img src="https://legionofandy.files.wordpress.com/2016/08/how-to-color-comics-the-marvel-way_64c_screener.jpg" alt="CMYK" width="400">|
|:---:| :---: |
|*(Image credit: © [Legion of Andy](https://legionofandy.com/))*|*(Image credit: © [Legion of Andy](https://legionofandy.com/))*|


## Implementation

### Flat Shade

|<img src="images/spider-man/spider-man.png" alt="Spider Man" width="800">|
|:---:|
|*(Image credit: © [PlayStation](https://www.playstation.com/en-us/games/marvels-spider-man/))*|

First, We have an image in hand to start. To shade it with Ben Day Dots later, we need to decide which part of the image need to be included for each pass, therefore the first step of the program need to separate the CMYK components of the image, which they will call [color separation]((shaders/separate.glsl)). The basic idea is to convert RGB space to CMYK space then based on the color of each channel, we divide the continuous value into 3 discrete shades (light, dark, and solid). 

| | Yellow | Magenta | Cyan | Black | Outline |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Separated | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta.png) | ![cyan single pass](images/spider-man/cyan.png) | ![black single pass](images/spider-man/black.png) | ![black outline](images/spider-man/outline.png) |
| Progressive | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta-p.png) | ![cyan single pass](images/spider-man/cyan-p.png) | ![black single pass](images/spider-man/black-p.png) | ![black outline](images/spider-man/outline-p.png) |


For black, in particular, I added the option to include [outline](shaders/outline.glsl) into the shading, which is computed using central differences.

The results is shown below:

| Original | Flat Shade | With Outline |
| :---: | :---: | :---: |
| ![Origianl](images/spider-man/spider-man.png) | ![Flat Shade](images/spider-man/black-p.png) | ![With Outline](images/spider-man/outline-p.png)  |

### Shade with Ben-Day Dots

By vertically and horizontally repeating dots (small circles) and varying their spacing we can approximate the [shade (called screen)](shaders/screen.glsl) that we want:

|<img src="images/screens/color_board.png" alt="Color board" width="800">|
|:---:|
| *Color Board: approximate shade using dots followed by actual shade for each color, 3 shades for each* |

Without enforcing anti-aliasing, the dots we draw actaully looks like the dots printed on the newspaper in the old days because they are not perfect! However, to avoid generating unwanted effects (moire patterns), there are some [standards](http://the-print-guide.blogspot.co.uk/2009/05/halftone-screen-angles.html) such as the one below that we can follow to rotate the screen:

|<img src="https://legionofandy.files.wordpress.com/2016/08/screen-angles.jpg" alt="screen angles" width="600">|
|:---:|
|*(Image credit: © [Legion of Andy](https://legionofandy.com/))*|*(Image credit: © [Legion of Andy](https://legionofandy.com/))*|

But most of the examples from real comics used the following angles, so I use these instead.
- Cyan - 135 degrees
- Yellow - 105 degrees
- Magenta - 75 degrees
- Black - 45 degrees

Without further ado, by replacing the flat shade creating before with approximate shade using dots, and [compositing](shaders/composite.glsl) them together with the [paper](shaders/paper.glsl) texture:

| Original | Flat Shade | With Outline |
| :---: | :---: | :---: |
| ![Origianl](images/spider-man/spider-man.png) | ![Ben Dots](images/spider-man/spider-man-dots.png) | ![With Outline](images/spider-man/spider-man-paper-outline.png)  |

## TODOs
- [ ] Polish thoughts
  - [ ] better flat shading
  - [ ] adjust dot size and space
  - [x] grey shade
  - [x] appropriate screen angles
  - [ ] misregister
  - [ ] yellow is too bright
- [ ] Write-up

## References
1. [BEN DAY DOTS Series](https://legionofandy.com/2013/06/03/roy-lichtenstein-the-man-who-didnt-paint-benday-dots/)
