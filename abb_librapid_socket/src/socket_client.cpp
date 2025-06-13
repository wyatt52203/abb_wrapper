#include "abb_librapid_socket/socket_client.h"
#include <Poco/Exception.h>
#include <iostream>

using namespace abb::librapid_socket;

SocketClient::SocketClient(const std::string& ip, int port)
    : address_(ip, port), is_connected_(false) {}

void SocketClient::connect() {
    socket_.connect(address_);
    is_connected_ = true;
}

void SocketClient::sendBytes(const void* buffer, int length) {
    if (!is_connected_)
        throw Poco::IllegalStateException("Socket not connected");
    socket_.sendBytes(buffer, length);
}

void SocketClient::close() {
    if (is_connected_) {
        socket_.close();
        is_connected_ = false;
    }
}

