xxx = '11 2. 333 -5'
parse var xxx   nn oo pp qq rr
                                       /*assigns     11    ───►  NN     */
                                       /*assigns     2.    ───►  OO     */
                                       /*assigns    333    ───►  PP     */
                                       /*assigns     ─5    ───►  QQ     */
                                       /*assigns   "null"  ───►  RR     */

                           /*a  "null"  is a string of length zero (0), */
                           /*and is not to be confused with a null char.*/

parse value 1 2 3 with ss tt uu
                                       /*assigns     1     ───►  SS     */
                                       /*assigns     2     ───►  TT     */
                                       /*assigns     3     ───►  UU     */
parse value ss tt with tt ss
                                       /*swaps SS and TT                */
