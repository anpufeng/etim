//
//  main.cpp
//  ETImServer
//
//  Created by Ethan on 14/7/28.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include <iostream>
#include <signal.h>

#if defined(__APPLE__) && defined(__GNUC__)
#include <mysql.h>
#elif defined(__linux__) || defined(__linux)
#include <mysql.h>
#else
#include <mysql.h>
#endif

#include "Server.h"
#include "Singleton.h"
#include "glog/logging.h"

using namespace etim;
using namespace etim::pub;

int main(int argc, const char * argv[])
{
    // insert code here...
    
    /*
    typedef char int8;
    typedef int16_t int16;
    typedef int32_t int32;
    typedef int64_t int64;
    
    typedef unsigned char uint8;
    typedef unsigned short uint16;
    typedef unsigned int uint32;
    typedef unsigned long uint64;
    
    printf("char %d\n", (int)sizeof(char));
    printf("int16_t %d\n", (int)sizeof(int16_t));
    printf("int32_t %d\n", (int)sizeof(int32_t));
    printf("int64_t %d\n", (int)sizeof(int64_t));
    printf("unsigned char %d\n", (int)sizeof(unsigned char));
    printf("unsigned short %d\n", (int)sizeof(unsigned short));
    printf("unsigned int %d\n", (int)sizeof(unsigned int));
    printf("unsigned long %d\n", (int)sizeof(unsigned long));
    
    LOG_INFO<<"Log info";
    LOG_DEBUG<<"Log debug";
    LOG_WARN<<"Log warn";
    LOG_ERROR<<"Log error";
    
    
    MYSQL *connection, mysql;
    mysql_init(&mysql);
    connection = mysql_real_connect(&mysql,"127.0.0.1","root","","etim",0,0,0);
    if (connection == NULL) {
        //unable to connect
        printf("Connect error!\n");
    } else {
        printf("Connected.\n");
    }
     */
    
    google::SetLogDestination(0,"/Users/sss/Desktop/glog_log/info.log");
    
    google::InitGoogleLogging(argv[0]);
    
#ifdef DEBUG_MODE
    google::SetStderrLogging(google::GLOG_INFO); //设置级别高于 google::INFO 的日志同时输出到屏幕
#else
    google::SetStderrLogging(google::GLOG_INFO);//设置级别高于 google::FATAL 的日志同时输出到屏幕
#endif
    
    FLAGS_logbufsecs = 0; //缓冲日志输出，默认为30秒，此处改为立即输出
    FLAGS_max_log_size = 20; //最大日志大小为 100MB
    FLAGS_stop_logging_if_full_disk = true; //当磁盘被写满时，停止日志输出
    //google::SetLogFilenameExtension("91_"); //设置文件名扩展，如平台？或其它需要区分的信息
    //google::InstallFailureSignalHandler(); //捕捉 core dumped (linux)
    //google::InstallFailureWriter(&Log); //默认捕捉 SIGSEGV 信号信息输出会输出到 stderr (linux)
    
    signal(SIGPIPE, SIG_IGN);

    return Singleton<Server>::Instance().Start();
}

void signal_handler(int signo)
{
    LOG(ERROR)<<"收到signal "<<signo;
}

/*
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#define TIME_OUT_TIME 20 //connect超时时间20秒
int main(int argc , char **argv)
{
    
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if(sockfd < 0) exit(1);
    struct sockaddr_in serv_addr;
    //以服务器地址填充结构serv_addr
    int error=-1, len;
    len = sizeof(int);
    timeval tm;
    fd_set set;
    unsigned long ul = 1;
    ioctl(sockfd, FIONBIO, &ul); //设置为非阻塞模式
    bool ret = false;
    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) ==
       -1)
    {
        tm.tv_set = TIME_OUT_TIME;
        tm.tv_uset = 0;
        FD_ZERO(&set);
        FD_SET(sockfd, &set);
        if( select(sockfd+1, NULL, &set, NULL, &tm) > 0)
        {
            getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &error, (socklen_t *)&len);
            if(error == 0) ret = true;
            else ret = false;
        } else ret = false;
    }
    else ret = true;
    ul = 0;
    ioctl(sockfd, FIONBIO, &ul); //设置为阻塞模式
    if(!ret)
    {
        close( sockfd );
        fprintf(stderr , "Cannot Connect the server!n");
        return;
    }
    fprintf( stderr , "Connected!n");
    //下面还可以进行发包收包操作
}
 */
