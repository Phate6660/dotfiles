const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#060605", /* black   */
  [1] = "#A72C13", /* red     */
  [2] = "#7D825F", /* green   */
  [3] = "#919563", /* yellow  */
  [4] = "#9DA08F", /* blue    */
  [5] = "#C3BD90", /* magenta */
  [6] = "#CFC896", /* cyan    */
  [7] = "#dedede", /* white   */

  /* 8 bright colors */
  [8]  = "#9b9b9b",  /* black   */
  [9]  = "#A72C13",  /* red     */
  [10] = "#7D825F", /* green   */
  [11] = "#919563", /* yellow  */
  [12] = "#9DA08F", /* blue    */
  [13] = "#C3BD90", /* magenta */
  [14] = "#CFC896", /* cyan    */
  [15] = "#dedede", /* white   */

  /* special colors */
  [256] = "#060605", /* background */
  [257] = "#dedede", /* foreground */
  [258] = "#dedede",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
