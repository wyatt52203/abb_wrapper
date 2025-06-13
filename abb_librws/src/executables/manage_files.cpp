#include <iostream>
#include <abb_librws/rws_interface.h>
#include <Poco/Net/Context.h>
#include <fstream>
#include <sstream>
#include <string>

// Reads an entire file into a std::string
std::string readFileAsString(const std::string& filepath)
{
  std::ifstream file(filepath, std::ios::in | std::ios::binary);
  if (!file)
  {
    throw std::runtime_error("Failed to open file: " + filepath);
  }

  std::ostringstream contents;
  contents << file.rdbuf();
  return contents.str();
}


int main()
{
    std::string ip = "192.168.15.81";
    std::string username = "Admin";
    std::string password = "robotics";

    // Create Poco SSL context with no verification (self-signed certs likely)
    const Poco::Net::Context::Ptr ptrContext(new Poco::Net::Context( Poco::Net::Context::CLIENT_USE, "", "", "", Poco::Net::Context::VERIFY_NONE));

    // Create RWS interface
    abb::rws::RWSInterface rws_interface(ip, username, password, ptrContext);

    // Turn off existing processes
    std::cout << "program off: " << rws_interface.stopRAPIDExecution() << std::endl;

    // Upload/overwritefiles
    std::string file_content = readFileAsString("/root/catkin_ws/src/abb_wrapper/abb_librws/src/executables/rapid_programs/test.mod");
    abb::rws::RWSClient::FileResource upload_resource("simple_arm_ctl.mod", "Home/Programs/Wizard");
    std::cout << "upload file: " << rws_interface.uploadFile(upload_resource, file_content) << std::endl;
    

    // Request MasterShip (Required to reset program pointer)
    std::cout << "requesting mastership: " << rws_interface.requestMasterShip() << std::endl;
    std::cin.get();

    // loading rapid task?
    abb::rws::RWSClient::FileResource program("simple_arm_ctl.pgf", "Home/Programs/Wizard");
    std::cout << "load file: " << rws_interface.loadFileToRapid(program) << std::endl; 
    
    std::cout << "releasing mastership: " << rws_interface.releaseMasterShip() << std::endl;
    std::cin.get();
    
    return 0;
}
