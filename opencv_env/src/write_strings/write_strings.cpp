#include <iostream> 
#include <fstream> 
#include <vector> 
#include <string> 
#include <sstream> 

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        std::cout << "At leaset one input file. " << std::endl; 
        return 0; 
    }

    std::ifstream input_file; 
    input_file.open(argv[1], std::ios_base::in); 
    if (!input_file.is_open())
    {
        std::cerr << "Failed to open file: " << argv[1] << std::endl; 
        return -1; 
    }

    std::vector<std::string> strings; 
    std::string line; 

    while (std::getline(input_file, line))
    {
        strings.push_back(line); 
    }

    std::cout << "==========\nstrings: \n==========" << std::endl; 
    for (auto item : strings)
    {
        std::cout << item << std::endl; 
    }

    input_file.clear();
    input_file.close();

    std::cout << "==========\nWrite file. \n==========" << std::endl;
    std::ofstream output_file;
    output_file.open("copy.txt", std::ios_base::trunc); 
    if (!output_file.is_open())
    {
        std::cerr << "Failed to open file: " << "copy.txt" << std::endl; 
        return -1; 
    }  

    for (auto item : strings)
    {
        output_file << item << '\n';
    }

    output_file.close();

    return 0; 
}