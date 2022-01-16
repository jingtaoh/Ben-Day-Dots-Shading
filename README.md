# Ben-Day-Dots-Shading
My attempt to achieve ben-day dots effect in comic book.

|  | Yellow | Magenta | Cyan | Black |
| :---: | :---: | :---: | :---: | :---: |
| Single | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta.png) | ![cyan single pass](images/super-man/cyan.png) | ![black single pass](images/super-man/black.png) |
| Progressive | ![yellow single pass](images/super-man/yellow.png) | ![magenta single pass](images/super-man/magenta-p.png) | ![cyan single pass](images/super-man/cyan-p.png) | ![black single pass](images/super-man/black-p.png) |

## TODOs
- [x] [Paper texture](shaders/paper.glsl)

![yellow](images/super-man/blend-paper.png)

- [x] CMYK color separation
### comparison
| Before | After |
| :---: | :---: |
| ![Before](images/spider-man/spider-man.png) | ![After](images/spider-man/spider-man-paper.png) |

### progressive
| | Yellow | Magenta | Cyan | Black |
| :---: | :---: | :---: | :---: | :---: |
| Single | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta.png) | ![cyan single pass](images/spider-man/cyan.png) | ![black single pass](images/spider-man/black.png) |
| Progressive | ![yellow single pass](images/spider-man/yellow.png) | ![magenta single pass](images/spider-man/magenta-p.png) | ![cyan single pass](images/spider-man/cyan-p.png) | ![black single pass](images/spider-man/black-p.png) |


- [ ] CMYK with dots

## References
1. [BEN DAY DOTS Series](https://legionofandy.com/2013/06/03/roy-lichtenstein-the-man-who-didnt-paint-benday-dots/)