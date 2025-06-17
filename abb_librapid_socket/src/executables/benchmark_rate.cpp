#include "abb_librapid_socket/socket_client.h"
#include <iostream>
#include <chrono>

using namespace abb::librapid_socket;
using namespace std::chrono;

int main() {
    try {
        SocketClient client("192.168.15.81", 1025);
        client.connect();
        std::cout << "Connected to ABB controller for benchmarking.\n";

        const int total_msgs = 1000;

        auto start = high_resolution_clock::now();

        for (int i = 0; i < total_msgs; ++i) {
	    char msg = '1' + (i % 4);
            client.sendBytes(&msg, 1024);

            // Optional: if RAPID echoes the byte back, enable this:
            char reply;
            client.receiveBytes(&reply, 1024);
	    std::cout << "recieved: " << reply << std::endl;

	    std::this_thread::sleep_for(std::chrono::milliseconds(5));
        }

        auto end = high_resolution_clock::now();
        auto duration = duration_cast<milliseconds>(end - start).count();

        std::cout << "Sent " << total_msgs << " messages in " << duration << " ms.\n";
        std::cout << "Average send rate: " << (1000.0 * total_msgs / duration) << " messages/sec\n";

        client.close();
    } catch (const Poco::Exception& ex) {
        std::cerr << "POCO Exception: " << ex.displayText() << std::endl;
        return 1;
    }

    return 0;
}

