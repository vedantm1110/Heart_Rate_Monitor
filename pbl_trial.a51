//Heart Rate monitor
//






ORG 000H                   // origin
MOV DPTR,#LUT              // moves starting address of LUT to DPTR
MOV P1,#00000000B          // sets P1 as output port
MOV P0,#00000000B          // sets P0 as output port
MAIN: MOV R6,#230D         // loads register R6 with 230D
      SETB P3.5            // sets P3.5 as input port
      MOV TMOD,#01100001B  // Sets Timer1 as Mode2 counter & Timer0 as Mode1 timer
      MOV TL1,#00000000B   // loads TL1 with initial value
      MOV TH1,#00000000B   // loads TH1 with initial value
      SETB TR1             // starts timer(counter) 1
BACK: MOV TH0,#00000000B   // loads initial value to TH0
      MOV TL0,#00000000B   // loads initial value to TL0
      SETB TR0             // starts timer 0
HERE: JNB TF0,HERE         // checks for Timer 0 roll over
      CLR TR0              // stops Timer0
      CLR TF0              // clears Timer Flag 0
      DJNZ R6,BACK
      CLR TR1              // stops Timer(counter)1
      CLR TF0              // clears Timer Flag 0
      CLR TF1              // clears Timer Flag 1
      ACALL DLOOP          // Calls subroutine DLOOP for displaying the count
      SJMP MAIN            // jumps back to the main loop
DLOOP: MOV R5,#252D
BACK1: MOV A,TL1           // loads the current count to the accumulator
       MOV B,#4D           // loads register B with 4D
       MUL AB              // Multiplies the TL1 count with 4
       MOV B,#100D         // loads register B with 100D
       DIV AB              // isolates first digit of the count
       SETB P1.0           // display driver transistor Q1 ON
       ACALL DISPLAY       // converts 1st digit to 7seg pattern
       MOV P0,A            // puts the pattern to port 0
       ACALL DELAY
       ACALL DELAY
       MOV A,B
       MOV B,#10D
       DIV AB              // isolates the second digit of the count
       CLR P1.0            // display driver transistor Q1 OFF
       SETB P1.1           // display driver transistor Q2 ON
       ACALL DISPLAY       // converts the 2nd digit to 7seg pattern
       MOV P0,A
       ACALL DELAY
       ACALL DELAY
       MOV A,B             // moves the last digit of the count to accumulator
       CLR P1.1            // display driver transistor Q2 OFF
       SETB P1.2           // display driver transistor Q3 ON
       ACALL DISPLAY       // converts 3rd digit to 7seg pattern
       MOV P0,A            // puts the pattern to port 0
       ACALL DELAY         // calls 1ms delay
       ACALL DELAY
       CLR P1.2
       DJNZ R5,BACK1       // repeats the subroutine DLOOP 100 times
       MOV P0,#11111111B
       RET

DELAY: MOV R7,#250D        // 1ms delay
 DEL1: DJNZ R7,DEL1
       RET

DISPLAY: MOVC A,@A+DPTR    // gets 7seg digit drive pattern for current value in A
         CPL A
         RET
LUT: DB 3FH                // LUT starts here
     DB 06H
     DB 5BH
     DB 4FH
     DB 66H
     DB 6DH
     DB 7DH
     DB 07H
     DB 7FH
     DB 6FH
END