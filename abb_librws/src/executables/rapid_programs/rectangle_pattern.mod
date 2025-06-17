MODULE slider_arm_ctl
    VAR socketdev udp_socket;
    VAR string client_ip;
    VAR num client_port;
    VAR string msg;
    VAR string cmd;
    VAR string value;
    VAR num str_length;
    VAR num parsed_val;
    VAR robtarget target;
    VAR bool success;
    VAR speeddata speed := v100;
    VAR bool left_to_right := TRUE;
    VAR num y;
    VAR num z;
    VAR num dz;
    
    ! web params
    VAR num spd := 100;
    VAR num int := 10;
    VAR num lft := -600;
    VAR num rgt := 600;
    VAR num upr := 700;
    VAR num lwr := 100;
    
    
    PROC main()
        SocketCreate udp_socket \UDP;
        SocketBind udp_socket, "192.168.15.81", 1025;
        TPWrite "UDP server ready.";


        !receive   
        WHILE TRUE DO
            SocketReceiveFrom udp_socket \Str := msg, client_ip, client_port;
            
            cmd := StrPart(msg, 1, 3);
            TPWrite "cmd: " + cmd;
            str_length := StrLen(msg);
            value := StrPart(msg, 5, (str_length - 4));
            TPWrite "val: " + value;
            success := StrToVal(value, parsed_val);

            if success THEN
                TEST cmd
                    CASE "spd":
                        spd := parsed_val;
                        speed := [spd, 1000, 5000, 1000];
                    CASE "int":
                        int := parsed_val;
                    CASE "lft":
                        lft := parsed_val;
                    CASE "rgt":
                        rgt := parsed_val;
                    CASE "upr":
                        upr := parsed_val;
                    CASE "lwr":
                        lwr := parsed_val;
                    CASE "go!":
                        dz := (upr - lwr) / int;  ! vertical step size

                        FOR z FROM upr TO lwr STEP -dz DO
                            IF left_to_right THEN
                                y := lft;
                                MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, z50, tool0;
                                y := rgt;
                                MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, z50, tool0;
                            ELSE
                                y := rgt;
                                MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, z50, tool0;
                                y := lft;
                                MoveL [[300, y, z], [0,1,0,0], [-1,-1,0,1], [9E9,9E9,9E9,9E9,9E9,9E9]], speed, z50, tool0;
                            ENDIF

                            ! Alternate direction (zig-zag)
                            left_to_right := NOT left_to_right;
                        ENDFOR
                ENDTEST
            ENDIF
            
        ENDWHILE        

        ERROR
            TPWrite "ERRNO: " + ValToStr(ERRNO);
            ! TRYNEXT;

        TPWrite "closing now";
        SocketClose udp_socket;
        
    ENDPROC


    
    
ENDMODULE



