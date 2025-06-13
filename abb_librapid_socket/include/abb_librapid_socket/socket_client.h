#ifndef ABB_LIBRAPID_SOCKET_CLIENT_H
#define ABB_LIBRAPID_SOCKET_CLIENT_H

#include <Poco/Net/StreamSocket.h>
#include <Poco/Net/SocketAddress.h>
#include <string>

namespace abb {
namespace librapid_socket {

class SocketClient {
public:
    SocketClient(const std::string& ip, int port);
    void connect();
    void sendBytes(const void* buffer, int length);
    void close();

private:
    Poco::Net::StreamSocket socket_;
    Poco::Net::SocketAddress address_;
    bool is_connected_;
};

} // namespace librapid_socket
} // namespace abb

#endif

