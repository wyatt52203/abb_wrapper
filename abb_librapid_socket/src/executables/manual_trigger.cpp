#include "abb_librapid_socket/socket_client.h"
#include <iostream>

using namespace abb::librapid_socket;

int main() {
    try {
        std::cout << "Connecting to ABB RAPID socket..." << std::endl;
        SocketClient client("192.168.15.81", 1025);
        client.connect();
        std::cout << "Connected to ABB controller.\n";

        std::cout << "Enter a number (1–4) to trigger motion. Ctrl+C to quit.\n";

        while (true) {
            std::cout << ">> ";
            char input = std::cin.get();  // Reads one char at a time (including newline)
            std::cin.ignore(1000, '\n');  // Clear input buffer

            if (input >= '1' && input <= '4') {
                client.sendBytes(&input, 1);
                std::cout << "Sent: " << input << std::endl;
            } else {
                std::cout << "Please enter a number between 1 and 4.\n";
            }
        }

        client.close();
        std::cout << "Connection closed.\n";

    } catch (const Poco::Exception& ex) {
        std::cerr << "POCO Exception: " << ex.displayText() << std::endl;
        return 1;
    }

    return 0;
}

