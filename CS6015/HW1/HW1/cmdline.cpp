//
//  cmdline.cpp
//  HW1
//
//  Created by Samantha Pope on 1/16/24.
//

#include <iostream>
#include <cstring> // For strcmp

#include "cmdline.hpp"


void useArgs(int argc, const char *argv[]) {
    
    static bool testAlreadyPressed = false;
    
    for(int i=1;i<argc;++i){
        //loop for all of it
        if(strcmp(argv[i], "--help") == 0) {
            std::cout << "Usage: ./msdscript [option]\n"
            << "Options:\n"
            << "  --help  Show this help message\n"
            << "  --test  Run tests\n";
            exit(0);
        }
        //have to control for if it is the first test that they wrote or not
        else if(strcmp(argv[i], "--test") == 0) {
            if(!testAlreadyPressed){
                testAlreadyPressed = true;
                std::cout << "Tests passed\n";
            }
            else{
                std::cerr << "Error: --test argument already seen\n";
                exit(1);
            }
        }
        
        else{
            std::cerr << "Error: Unknown argument:  " << argv[i] << "\n";
            exit(1);
        }
        
    }
}
