MODULE motion
    VAR bool left_to_right;
    VAR num y;
    VAR num z;
    
    ! interrupt param
    VAR intnum intno1;

    ! web params
    PERS num spd;
    PERS num int;
    PERS num lft;
    PERS num rgt;
    PERS num upr;
    PERS num lwr;
    PERS num acc;
    PERS num jrk;
    PERS num dac;
    PERS bool go;
    PERS bool play;
    PERS zonedata zone;
    PERS speeddata speed;
    
    
    
    PROC main()
        CONNECT intno1 WITH wait_trap;
        ISignalDO MyPauseSignal, 1, intno1;

        WHILE TRUE DO

            ! Wait for persistent variable signal
            WaitUntil go;

            ! Set Motion Parameters
            AccSet acc, jrk \FinePointRamp:=dac;
            left_to_right := TRUE;
            z := upr;

            WHILE z >= lwr DO
                IF left_to_right THEN
                    y := lft;
                    MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
                    y := rgt;
                    MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
                ELSE
                    y := rgt;
                    MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
                    y := lft;
                    MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
                ENDIF

                z := z - int;
                left_to_right := NOT left_to_right;
            ENDWHILE

            ! Reset go to wait for another signal
            go := FALSE;
            
        ENDWHILE        

        ERROR
            TPWrite "ERRNO: " + ValToStr(ERRNO);
            ! TRYNEXT;
    ENDPROC

    TRAP wait_trap
        WaitUntil play;
        SetDO MyPauseSignal, 0;
    ENDTRAP

    
    
ENDMODULE



