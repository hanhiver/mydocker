#include <iostream> 
#include <fstream> 
#include <regex> 

std::string get_container_id(std::string filename)
{
    std::string container_id {""};  

    std::ifstream cgroup_file; 
    //std::string cgroup_file_name = "/proc/1/cgroup";
    std::string cgroup_file_name = filename;

    cgroup_file.open(cgroup_file_name); 
    if (!cgroup_file.is_open())
    {
        std::cout << "Error opening file: " 
                  << cgroup_file_name << std::endl; 
        return container_id;
    }

    auto cgroup_line1_reg = std::regex("1:name=systemd:/"); 
    std::smatch match;  

    std::string line;
    while (std::getline(cgroup_file, line))
    {
        if (std::regex_search(line, match, cgroup_line1_reg))
        {
            std::string suffix(match.suffix().str()); 
            std::cout << suffix << std::endl; 
            
            auto docker_pos = suffix.find("docker");
            std::cout << "suffix length: " << suffix.length() 
                      << " docker_pos: " << docker_pos << std::endl; 

            if ( suffix.length() > docker_pos+70 && \
                docker_pos <= suffix.length())
            {
                container_id = suffix.substr(docker_pos+7, 64);
                
                std::cout << "In a container. " << std::endl; 
                std::cout << docker_pos << std::endl; 
                std::cout << container_id << std::endl;
                
            }
        }
    }

    cgroup_file.clear();
    cgroup_file.close();

    return container_id; 
}


int main(int argc, char* argv[])
{
    std::string docker_id = get_container_id(argv[1]); 

    if (!docker_id.empty())
    {
        std::cout << "In a container, ID: " 
                  << docker_id << std::endl;
    }
    else
    {
        std::cout << "Not in a container. " << std::endl; 
    }
     
    
}