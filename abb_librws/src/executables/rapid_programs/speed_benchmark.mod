MODULE speed_benchmark
    VAR socketdev mySocket;
    VAR socketdev clientSocket;
    VAR socketstatus stat;
    VAR string ipAddress := "192.168.15.81";  ! Controller IP
    VAR num port := 1025;
    VAR byte msg{1024};
    VAR byte send_msg{1024};
    VAR string typed_msg;
    
    PROC main()
        !delete old connections
        SocketClose clientSocket;
        SocketClose mySocket;
        
        !connect
        
        SocketCreate mySocket;
        SocketBind mySocket, ipAddress, port;
    
        SocketListen mySocket;
    
        TPWrite "Waiting for connection...";
        SocketAccept mySocket, clientSocket;
    
        TPWrite "Client connected!";
        
        !receive   
        WHILE TRUE DO
            SocketReceive clientSocket \Data:= msg;
            
            ! Print message no matter what
            TPWrite "Received: ";
            typed_msg := NumToStr(msg{1}, 3);
            TPWrite typed_msg;
            
            send_msg{1} := 65;  ! ASCII 'A'
            SocketSend clientSocket \Data:= send_msg;
        ENDWHILE        


        TPWrite "closing now";
        SocketClose clientSocket;
        SocketClose mySocket;
        
    ENDPROC

    
    
ENDMODULE
