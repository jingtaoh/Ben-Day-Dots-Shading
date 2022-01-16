# Ben-Day-Dots-Shading
My attempt to achieve ben-day dots effect in comic book.

|  | Yellow | Magenta | Cyan | Black |
| :---: | :---: | :---: | :---: | :---: |
| Single | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta.png) | ![cyan single pass](images/super-man/cyan.png) | ![black single pass](images/super-man/black.png) |
| Progressive | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta-p.png) | ![cyan single pass](images/super-man/cyan-p.png) | ![black single pass](images/super-man/black-p.png) |

## Features
### [Paper texture](shaders/paper.glsl)

| Before | After |
| :---: | :---: |
| ![Before](images/super-man/black-p.png) | ![After](images/super-man/blend-paper.png) |


### [Flat shading](shaders/separate.glsl)

| Before | After |
| :---: | :---: |
| ![Before](images/spider-man/spider-man.png) | ![After](images/spider-man/spider-man-paper.png) |

-  Color separation:

| | Yellow | Magenta | Cyan | Black |
| :---: | :---: | :---: | :---: | :---: |
| Single | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta.png) | ![cyan single pass](images/spider-man/cyan.png) | ![black single pass](images/spider-man/black.png) |
| Progressive | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta-p.png) | ![cyan single pass](images/spider-man/cyan-p.png) | ![black single pass](images/spider-man/black-p.png) |

### [Ben-Day dots](shaders/screen.glsl)

![color board](images/screens/color_board.png)

- [Composition](shaders/composite.glsl)

| Before | After |
| :---: | :---: |
| ![Before](images/spider-man/spider-man-paper.png)  | ![After](images/spider-man/spider-man-dots.png)|

## TODOs
- [] Polish thoughts
  - better flat shading
  - adjust dot size and space

## References
1. [BEN DAY DOTS Series](https://legionofandy.com/2013/06/03/roy-lichtenstein-the-man-who-didnt-paint-benday-dots/)