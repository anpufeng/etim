//
//  DataService.cpp
//  ETImServer
//
//  Created by Ethan on 14/8/8.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#include "DataService.h"
#include "MysqlDB.h"
#include "Logging.h"

#include <sstream>

using namespace etim;
using namespace std;

int DataService::UserRegister(const std::string &user, const std::string &pass) {
    try {
        MysqlDB db;
        db.Open();
        db.StartTransaction();
        stringstream ss;
        ss<<"insert into user values(null, '"<<
        user<<"', '"<<
        pass<<"', '"<<
        ", now(), "<<
        ", now(), "<<
        0<<");";
		unsigned long long ret = db.ExecSQL(ss.str().c_str());
        
        
		ss.clear();
		ss.str("");
		account.account_id = static_cast<int>(db.GetInsertId());
		ss<<"insert into trans values(null, "<<
        account.account_id<<", null, "<<
        1<<", "<<
        setprecision(2)<<setiosflags(ios::fixed)<<account.balance<<", "<<
        setprecision(2)<<setiosflags(ios::fixed)<<account.balance<<
        ",  now());";
        
		ret = db.ExecSQL(ss.str().c_str());
        
		db.Commit();
        
		ss.clear();
		ss.str("");
		ss<<"select open_date from bank_account where account_id='"<<
        account.account_id<<"';";
		MysqlRecordset rs = db.QuerySQL(ss.str().c_str());
		account.op_date = rs.GetItem(0, "open_date");
    } catch (<#catch parameter#>) {
        <#statements#>
    }
    return 0;
}


