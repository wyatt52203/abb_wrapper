#include <Poco/Net/DatagramSocket.h>
#include <Poco/Net/SocketAddress.h>
#include <Poco/Exception.h>
#include <iostream>
#include <thread>

int main() {
    try {
        std::string robot_ip = "192.168.15.81";  // IP of the ABB controller
        int robot_port = 1025;                   // Port RAPID is listening on
        Poco::Net::SocketAddress robot_addr(robot_ip, robot_port);

        // Create UDP socket and bind it to any local port
	Poco::Net::DatagramSocket socket;  // Create an unbound socket
	socket.bind(Poco::Net::SocketAddress(Poco::Net::IPAddress(), 50500));  

	std::string msg = "hello world";
        socket.sendTo(msg.data(), msg.size(), robot_addr);
        std::cout << "Sent: " << msg << " to " << robot_ip << ":" << robot_port << std::endl;

        // Wait for reply
        //char buffer[1024] = {0};
        //Poco::Net::SocketAddress sender;
        //int received = socket.receiveFrom(buffer, sizeof(buffer), sender);

        //std::cout << "↩️ Received " << received << " byte(s) from " << sender.toString()
        //         << ": " << static_cast<int>(buffer[0]) << std::endl;
	
	int total_msgs = 10000;

	auto start = std::chrono::high_resolution_clock::now();
	for (int i = 0; i < total_msgs; ++i) {
		std::string msg = std::to_string(i);
		socket.sendTo(msg.data(), msg.size(), robot_addr);
		std::this_thread::sleep_for(std::chrono::milliseconds(1));
	}
	auto end = std::chrono::high_resolution_clock::now();

	auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
	std::cout << "Sent " << total_msgs << " packets in " << duration << " ms\n";
	std::cout << "≈ " << (1000.0 * total_msgs / duration) << " packets/sec\n";


        socket.close();
    } catch (const Poco::Exception& ex) {
        std::cerr << "POCO Exception: " << ex.displayText() << std::endl;
        return 1;
    }

    return 0;
}

