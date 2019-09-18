## Color Blending

### Alpha Blend

$$out_A = src_A + dst_A(1 - src_A)$$
$$out_C = \frac{src_C src_A + dst_C dst_A(1 - src_A)}{out_A}$$

if $out_A = 0$

then $out_C = 0$

### Bilinear Image Scaling

```
                 <------- W ------>
                 <--- w --->
                 A.........I......B ^ ^
                 .................. | |
                 .................. h |
AB   enlarge     .................. | |
CD ----------->  ..........X....... v H
                 ..................   |
                 ..................   |
                 C.........J......D   v
```
let $W=H=1$

$$\frac{I-A}{w}=\frac{B-A}{W}$$
$$I=A+w(B-A)$$

same for

$$J=C+w(D-C)$$

combine both linear eqs

$$\frac{X-I}{h}=\frac{J-I}{H}$$
$$X=I+h(J-I)$$

then

$$X=A(1-w)(1-h)+Bw(1-h)+Ch(1-w)+Dwh$$