
//{$INCLUDE 'F:\LED Display\Delphi\MAIN\LED Display Control Software\Project\ConfigModel.inc'}

//----------------------------------------------------
//* Full Bright Models                              */
{$if defined(_BR_MODEL_1_)}
      GLOBAL_ENCRYPTION_KEY = 'h89@jdklG-s12V';
      REG_ENCODE_KEY = 'lo23pDr6HD98Z+w';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '8Fj2#2kxlmXm2',
        '945Tjdo#k12@k',
        'jfn%k983kF-A2',
        'nv+j%jflDSk9o',
        'sDx34tdSf8%^k',
        'sD3R23G6$f+c=',
        'vhj#kWE2mo9-Z',
        'g%hj32VkS2l(0',
        '3Df76Gm2G;l01',
        'nf4jGl3@09ClA',
        'm9@3kS-+kg78v',
        'xo$kzQ9Lp2a21',
        'ml!2jD09+xdF2',
        'cf$589GtjFl21',
        'xD4o+0#21jK67',
        'clpD+4$6dUi87'
      );
{$ifend}

{$if defined(_BR_MODEL_2_)}
      GLOBAL_ENCRYPTION_KEY = '8gHi32An90@VBD';
      REG_ENCODE_KEY = 'l[23Sw90FT3}1@g';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'fgt672jDk(2@m',
        'xcv@13+-d=Gtu',
        'IoeSw45cD981x',
        'zLap23Fv*09gh',
        '2Rr45eP+zSk78',
        'v$j73#jg12XDo',
        's@1k+rlk=%jVF',
        'xDf45GmLo32ct',
        '1@fdloG;l87#d',
        'sdh#4ms10hhyt',
        'CH74OS$37PFS!',
        'DLP+RI9MASHsD',
        'Dfj@3jk2GTl89',
        'dm@309ftjDmck',
        'dj#kk43@m38ol',
        'db#4ijmHyp0A1'
      );
{$ifend}

{$if defined(_BR_MODEL_3_)}
      GLOBAL_ENCRYPTION_KEY = 'b7%55uiq\z_34h';
      REG_ENCODE_KEY = 'nmVk,S45]kS/kfR';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'h%47Fdol#p2!l',
        'xn0$lkdjkjgDl',
        's@2jDF87TTxS1',
        'q!2lF+fjkk-$k',
        'ednh564Fkfhn0',
        'bdg@3y6kE893j',
        'd#kjkk+Gl=3kf',
        'hf$ghHlfiE38D',
        'Cvng$j82@S21!',
        'mLdo09Ddj4=3d',
        'sd3l+FRkeg$56',
        'dk#kfu+%llDGl',
        'dj$jfkDndmE@3',
        'dF3mfl23Fllo0',
        'gd#4hFld+%78d',
        'DgbHgr78Fl!2l'
      );
{$ifend}
//----------------------------------------------------

{$if defined(_MODEL_WITH_COLOR_)}
  {$ifndef _MODEL_1_}
    {$MESSAGE Error 'ERROR: Color display is only for 16-row display.'}
  {$endif}
  {$ifndef _MODEL_WITH_LFG_}
    {$MESSAGE Error 'ERROR: LED Font Generator must be included with color display.'}
  {$endif}
  {$ifdef _MODEL_WITH_ALARM_}
    {$MESSAGE Error 'ERROR: Alarm must not be enabled on the color display.'}
  {$endif}
      GLOBAL_ENCRYPTION_KEY = 'E2tyNcNb7^p[Za';
      REG_ENCODE_KEY = 'flp^5-0kFdlo32F';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'Fr4-%kf}doE3x',
        'vFrl$3d+Gtk6k',
        'vFrk78*lofDps',
        'cDel3@+f;l9Cd',
        'cD2kd)6lfnmsN',
        'v,lTopfDkPrjS',
        'DfkE45GTRpvD;',
        'dEl$ld9^mg+&k',
        'Fk^kd0Yo6;2dW',
        'dQk@1i+6lFpoc',
        'cFNmFdl4D>k#@',
        'cDfkP=trio&oE',
        'Sw@EkkGvl78GF',
        'f$k560GY6kCdo',
        'cDek32+pl^oFd',
        'cfRj6ogYYi+@d'
      );
{$else}

//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 1
{$if defined(_MODEL_1_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 'A0c3y@8X!0JpVH';
      REG_ENCODE_KEY = 'O0[t!4=3fy&Gbc9';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'wFggp40)%flXa',
        'gry5RDwss;pq]',
        'zBf!52d82UipQ',
        'aqSg5^hbf1vLp',
        '~12fgI7c9)fdr',
        'vNyklh7860bNt',
        '3rTtG3iVdDgD1',
        '=5Gfgxclkbd0+',
        '-4lWqa07xfCvZ',
        'dmkpc%675aTqA',
        '\]d6l:xXspqqW',
        'XdFgErt@bNse4',
        '1@3dSggKf(8ym',
        '4FgHrE45T8fZc',
        'vjfyIidW83W-0',
        'z+puJl83lpmvC'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = 'IR398cv1aS345N';
      REG_ENCODE_KEY = 'uRbH73k0lo^=Q-b';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'wF3rp30)dfcXa',
        'gry5cDDssd4q]',
        'zB34525hjnipQ',
        'aqSaqlopx1vLp',
        '~12fgI7r5gnm8',
        'vNyklhdf34bNt',
        '3rTdsw35gbgD1',
        '=5Gs1xhlkyu8+',
        '-4cnko0d4rc1Z',
        'nni%j59wSxZp[',
        ']\jf|fkm!2koR',
        'ioYubFvk0*0#j',
        '2sD#4jgn+-0bv',
        'w@kdxLOpajhT%',
        '~ffXtgJdix(h0',
        'h5%jg^jc*j@#Q'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '76jgS@3$sL"lB}';
      REG_ENCODE_KEY = '@df%Ghb+0)bb&*=';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'dk5%6jv@jdo&i',
        'cmvioqEFhk$33',
        '33jndop^ykbsp',
        '1@34+gg8f&kaE',
        'sWrk^l97v+kED',
        'xCdF3#rk+7^j%',
        '#fmBndDlo\gi/',
        'yTbCDkSl)kF34',
        '-_=2$hg^iOdSC',
        'sWeBnjH8%4k0w',
        'jGfl$l+)dk&k@',
        'CdsZBhVJck#1f',
        'nbTmgoPdjDEl{',
        '}fj\dk@jd^fgj',
        'bDcerwi%892vU',
        'W2%)9jf&h*vCE'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = 'Tr$sV!k+Oi4hNE';
      REG_ENCODE_KEY = 'nr$8jf6SjK89W22';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'kWekfl{fk%4k0',
        'sW2tCvmLGKdp4',
        'xNb32%fk^,Azl',
        '@1j$jfoP0{+-6',
        'o$jfFkD0(k!2=',
        'xZsBnh8%kN$od',
        '1@~sEr$tk+j&k',
        'CvgF^o(f9f4DY',
        'fD4of+0v2mXzl',
        ';jro}[4$kdy^D',
        'aZdk(iTrk~k]c',
        'Fgt78Sw\dw|$4',
        'xSd9fj88fGkCo',
        'f$3f+6kVnGSwQ',
        'Cxd$3k*9fVbl@',
        'cNgYgkDb{;UiZ'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 2
{$if defined(_MODEL_2_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 'WDl:$>2!rGjitp';
      REG_ENCODE_KEY = 'dh45#kvc0YjSxBS';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'opWErfGRb67Xg',
        'fRjCXm56H[pf@',
        'w!2vm,T6%l]o\',
        'cVgD7^7Hn4cXj',
        'zVn>g//f?k340',
        'cGj@woDSkgP0-',
        'cDfk@!lf+k5Bx',
        'x#rkg^lf0Ti8s',
        'xFgke@309gHlo',
        'cHnk%6flk9!2v',
        'vGhk$%ld!~l+0',
        'vGflNb67f$r%d',
        'cDfZaw53$k{c]',
        'd$5fdfoi^5f21',
        'cGhkSwkPlfO1f',
        'c]f|skl/f|\d#'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '9~FXewN[f&xcEV';
      REG_ENCODE_KEY = 'fk8$jsl@k0F+skW';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'j%dnFRe4nCxdO',
        'dEfkS#39^kcgs',
        'sW2k+8^kdElob',
        'xDf+5l$;^5@kT',
        'CRt0Y6k@pfDDv',
        'cJkiEj$30!2k)',
        'dSwi&gkr942vs',
        'd#24cf^%kHvBd',
        's@dk$59gGhaq9',
        'dE4+98fDkYkv^',
        's@f+5$k^7kRtv',
        'cDe23Y76hKlsW',
        'aW2f(d+&kB%dl',
        'f$fk%6,Vdsl*&',
        'dE3l%6l0d+k=s',
        's#eh$kmkx!2lP'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '3ER51!vXiFpn>(';
      REG_ENCODE_KEY = 'fh%4kn&l0]SmxzA';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'dk#2kk^5l+flk',
        'd#kdi$5kF+kGd',
        '\Fdl?l/f|p$5d',
        'xZsl#f4fl"k!o',
        's@k%4lCDl+o&0',
        'd#k^5oVCf&-d5',
        'De#2k%6g+d^k8',
        'cFl$3l8_lfDe#',
        's@1l_6lkDoXzs',
        'fl&tvmDEps932',
        'd|d[<sk%fQ1[c',
        'f$rjf^t9dl#|s',
        'cv|khmDu675jS',
        'vgHT6%k*lcdmR',
        'd#ek%FflmCll@',
        'D3k$l+dl^kCdl'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '9%f2K[XnIl8$BN';
      REG_ENCODE_KEY = 'jk%ksd#0.sdk@kA';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'k%kd_l&gkEwp#',
        'k%fkDE3o&yosw',
        'c}jlg\k<f,25Q',
        'k9%jd3hjTu?Cx',
        's@sg$0f)k*kER',
        'vGn#j+9fH5k@i',
        'g%i^k8+lk*ldE',
        's@sjVcFdm&k+0',
        'd#dj%fkvC8(l1',
        'x#k+6Fi*ldVdg',
        'c#j$tj^*kd+k*',
        'dFewo5Bh78d0!',
        'cF4h3%kswF5^k',
        'd#djY^ljWp]23',
        'dh$3kVc%d7SDl',
        'c#dj$32jUhF9+'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 3
{$if defined(_MODEL_3_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '7YfC+L:w#B7jCr';
      REG_ENCODE_KEY = 'd]sk$di@skp;pTc';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'sl$3kFdkpTk,A',
        'dWek#kf)dl6vD',
        'd#kd+f%kfYUlc',
        'x#dkLofp$5kxs',
        'd#ek%^okfe985',
        'd#dkGT5lBm021',
        's1#RfoPfi%icZ',
        's@1+6G^lDfLx^',
        'd#dlCxd+^l%kR',
        'Tg&kCdvfR6UJa',
        'dCfrGhjp^0eDl',
        'l)l&kF2sCfk$j',
        'dRk%kEWs;#4lf',
        'f$fk%ok+5^o@S',
        'dE3f+%4kFEDw@',
        'fFgl+%rkUFewQ'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '5^Yf*cD2@Ublqo';
      REG_ENCODE_KEY = 'Oprj%4ikdUIHkCe';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        's#ej+4k%6l&Fl',
        'dl#4kgk05dl8W',
        'i5#ej5jSxPyo6',
        'dE3k+6[}/"fl.',
        's@w+4%kYTmCdx',
        'dE34HJi(0f6kF',
        'dE34+^tl0k(kC',
        's@d+$3k^5kvGf',
        'e#456Gd8Xo)01',
        'd@3+&6o9DsZas',
        'dE34+t^5kBGcd',
        'd#e4+l^5kDevC',
        'x@3+^5kT9&kXs',
        'd@3+%l^lgFv>n',
        'fMbn$j+k6Do9)',
        'd@3+d$rkf^kXs'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 't0$k@xZp](tVeM';
      REG_ENCODE_KEY = 'j$4kd+k^kYu7D3e';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'd#ek+%4kfTYk&',
        'd#d+G6kgRpW23',
        'jr$5k+T5kFdl#',
        'dE3l;+%fkDE2s',
        'Del+%rlFRelSw',
        'fGri+^5l@#4vG',
        'fR43%lFrd+^la',
        'dE23+%fk90dCW',
        'cDflH]D>dkEmv',
        'dE<hlOj[|d#k6',
        'dVbzxre#4w24H',
        'fjTybV65^jDXn',
        'E2Fvk%gk+kCD,',
        'xDsr#4+lYgjVm',
        'fR,$k+H6kUiXs',
        'Xsl@3kP[f]Gjw'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = 'ly%qxpTb5]rxoZ';
      REG_ENCODE_KEY = 'is#4kd%5ogO+k[d';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        ']4Fl32+k%kCvH',
        'd@sh95GkCx;Aq',
        'd@wj+^lVflSx1',
        'f#kjLodpS[al0',
        'cDej38GgkRsp0',
        'dBnKl.w]>fk#2',
        'v>nS2pEp]+\?<',
        'dF4l+@90RcdS2',
        'fEj3+2kjHkcn^',
        'fR4lGVxl+^09D',
        'dSw2;"f]Trbxz',
        'nAzRlBr02f45%',
        '#f%$;odspjQaz',
        'cVg7%lkfPOmVC',
        'dEh3G+l&glDck',
        'Deh#2+gkE$5kV'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////

{$ifend}
