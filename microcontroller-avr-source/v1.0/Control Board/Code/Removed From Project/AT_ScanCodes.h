//PC AT Keyboard Scancodes

// Unshifted characters
typedef flash struct
{
  unsigned char sc;
  unsigned char unshifted;
  unsigned char shifted;
} KEY_ENTRY;

flash KEY_ENTRY normal_keys[82] = {
  0x0d, 9, 9,  //TAB
  0x0e,'|', '§',  //
  0x15,'q', 'Q',
  0x16,'1', '!',
  0x1a,'z', 'Z',
  0x1b,'s', 'S',
  0x1c,'a', 'A',
  0x1d,'w', 'W',
  0x1e,'2', '"',
  0x21,'c', 'C',
  0x22,'x', 'X',
  0x23,'d', 'D',
  0x24,'e', 'E',
  0x25,'4', '¤',  //
  0x26,'3', '#',
  0x29,' ', ' ',
  0x2a,'v', 'V',
  0x2b,'f', 'F',
  0x2c,'t', 'T',
  0x2d,'r', 'R',
  0x2e,'5', '%',
  0x31,'n', 'N',
  0x32,'b', 'B',
  0x33,'h', 'H',
  0x34,'g', 'G',
  0x35,'y', 'Y',
  0x36,'6', '&',  //
  0x39,',', 'L',
  0x3a,'m', 'M',
  0x3b,'j', 'J',
  0x3c,'u', 'U',
  0x3d,'7', '//',
  0x3e,'8', '(',
  0x41,',', ';',
  0x42,'k', 'K',
  0x43,'i', 'I',
  0x44,'o', 'O',
  0x45,'0', '=',
  0x46,'9', ')',
  0x49,'.', ':',
  0x4a,'-', '_',
  0x4b,'l', 'L',
  0x4c,'?', '?',  //
  0x4d,'p', 'P',
  0x4e,'+', '?',
  0x52,'?', '?',  //
  0x54,'?', '?',  //
  0x55,'\\', '`',  //
  0x5a, 13, 13,
  0x5b,'¨', '^',
  0x5d,'\'', '*',
  0x61,'<', '>',
  0x66, 8, 8,
  0x69,'1', '1',
  0x6b,'4', '4',
  0x6c,'7', '7',
  0x70,'0', '0',
  0x71,',', ',',
  0x72,'2', '2',
  0x73,'5', '5',
  0x74,'6', '6',
  0x75,'8', '8',
  0x79,'+', '+',
  0x7a,'3', '3',
  0x7b,'-', '-',
  0x7c,'*', '*',
  0x7d,'9', '9',

  //Function Keys
  0x05, 0, 0,  //F1
  0x06, 0, 0,  //F2
  0x04, 0, 0,  //F3
  0x0c, 0, 0,  //F4
  0x03, 0, 0,  //F5
  0x0b, 0, 0,  //F6
  0x83, 0, 0,  //F7
  0x0a, 0, 0,  //F8
  0x01, 0, 0,  //F9
  0x09, 0, 0,  //F10
  0x78, 0, 0,  //F11
  0x07, 0, 0,  //F12
  
  0x5a, 13, 13,  //ENTER
  0x76, 27, 27,  //ESC
  
  0, 0, 0
};


flash KEY_ENTRY extended_keys[68] = {
  0x70, 0, 48,  //INSERT
  0x6c, 0, 55,  //HOME
  0x7d, 0, 57,  //Page Up
  0x7a, 0, 51,  //Page Down
  0x71, 0, 46,  //DEL
  0x69, 0, 49,  //END
  0x75, 0, 56,  //Up Arrow
  0x72, 0, 50,  //Down Arrow
  0x6b, 0, 52,  //Left Arrow
  0x74, 0, 54,  //Right Arrow
  
  0, 0, 0
};

//Keymapping tables
flash unsigned char kbd_extended_keys_normal[21][2] =
{
  //Function Keys
  0x05, 59,  //F1
  0x06, 60,  //F2
  0x04, 61,  //F3
  0x0c, 62,  //F4
  0x03, 63,  //F5
  0x0b, 64,  //F6
  0x83, 65,  //F7
  0x0a, 66,  //F8
  0x01, 67,  //F9
  0x09, 68,  //F10
//  0x78,  //F11
//  0x07,  //F12

  0x70, 82,  //INSERT
  0x6c, 71,  //HOME
  0x7d, 73,  //Page Up
  0x7a, 81,  //Page Down
  0x71, 83,  //DEL
  0x69, 79,  //END
  0x75, 72,  //Up Arrow
  0x72, 80,  //Down Arrow
  0x6b, 75,  //Left Arrow
  0x74, 77,  //Right Arrow

  0, 0
};

flash unsigned char kbd_extended_keys_shifted[11][2] =
{
  //Function Keys
  0x05, 84,  //F1
  0x06, 85,  //F2
  0x04, 86,  //F3
  0x0c, 87,  //F4
  0x03, 88,  //F5
  0x0b, 89,  //F6
  0x83, 90,  //F7
  0x0a, 91,  //F8
  0x01, 92,  //F9
  0x09, 93,  //F10
//  0x78,  //F11
//  0x07,  //F12

  0, 0
};
