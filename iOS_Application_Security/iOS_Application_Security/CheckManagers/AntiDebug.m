//
//  AntiDebug.m
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

#import "AntiDebug.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#import <dlfcn.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#include <libgen.h>
#include <mach/processor_info.h>
#import "iOS_Application_Security-Swift.h"

@interface AntiDebug ()

@end

@implementation AntiDebug

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#define PT_DENY_ATTACH 31
processor_info_array_t cpuInfo, prevCpuInfo;
mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
unsigned numCPUs;


- (void)disable_gdb {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}

- (int)detect_injected_dylds {
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++) {
        const char *dyld = _dyld_get_image_name(i);
        if(!strstr(dyld, "MobileSubstrate") || !strstr(dyld, "cycript") || !strstr(dyld, "SSLKillSwitch") || !strstr(dyld, "SSLKillSwitch2")) {
            continue;
        }
        else {
            exit(0);
        }
    }
    return 0;
}

- (int) isDebugged {
    int name[4];
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    
    info.kp_proc.p_flag = 0;
    
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
        return 1;
    }
    return ((info.kp_proc.p_flag & P_TRACED) != 0);
    int (*func_stat)(const char *, struct stat *) = stat;
}

- (void) asmgdbsetting {
       __asm (
              "mov r0, #31\n"
              "mov r1, #0\n"
              "mov r2, #0\n"
              "mov r3, #0\n"
              "mov ip, #26\n"
              "svc #0x80\n"
              );
}

- (void)checkProcessWithCompletion:(void (^ _Nonnull)(BOOL))handler {
    [self isDebugged];
}

- (void)doucleCheckProcessWithCompletion:(void (^ _Nonnull)(BOOL))handler {
    return;
}

@end


