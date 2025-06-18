MODULE motion
    VAR bool left_to_right := TRUE;
    VAR num y;
    VAR num z;
    
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
    PERS zonedata zone;
    
    
    
    PROC main()
        !receive   
        WHILE TRUE DO
            TPWrite "spd: " + ValToStr(spd);
            TPWrite "stat: " + ValToStr(int);

            WaitTime 2;

            ! z := upr;

            ! WHILE z >= lwr DO
            !     IF left_to_right THEN
            !         y := lft;
            !         MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
            !         y := rgt;
            !         MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
            !     ELSE
            !         y := rgt;
            !         MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
            !         y := lft;
            !         MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, zone, tool0;
            !     ENDIF

            !     z := z - int;
            !     left_to_right := NOT left_to_right;
            ! ENDWHILE
            
        ENDWHILE        

        ERROR
            TPWrite "ERRNO: " + ValToStr(ERRNO);
            ! TRYNEXT;

        TPWrite "closing now";
        SocketClose udp_socket;
        
    ENDPROC


    
    
ENDMODULE



