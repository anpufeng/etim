#include "MysqlDB.h"
#include "Exception.h"
#include "Server.h"
#include "Singleton.h"

#include <string.h>

using namespace etim;
using namespace etim::pub;

#define MYSQL_SERVER        "localhost"
#define MYSQL_USER          "root"
#define MYSQL_PASSWOROD     ""
//#define MYSQL_USER          "etim"
//#define MYSQL_PASSWOROD     "ethan2014XU"
#define MYSQL_DATABASE      "etim"
#define MYSQL_PORT          3306

MysqlDB::MysqlDB() : mysql_(NULL)
{
}

MysqlDB::~MysqlDB()
{
	if (mysql_)
	{
		Close();
	}
}

void MysqlDB::Open() {
    Open(Singleton<Server>::Instance().GetDbServerIp().c_str(),
         Singleton<Server>::Instance().GetDbUser().c_str(),
         Singleton<Server>::Instance().GetDbPass().c_str(),
         Singleton<Server>::Instance().GetDbName().c_str(),
         Singleton<Server>::Instance().GetPort());
}
void MysqlDB::Open(const char* host,
				   const char* user,
				   const char* passwd,
				   const char* db,
				   unsigned int port)
{

	mysql_ = mysql_init(NULL);
	if (mysql_ == NULL)
	{
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}

	my_bool reconnect = true;
	mysql_options(mysql_, MYSQL_OPT_RECONNECT, &reconnect);
	mysql_options(mysql_, MYSQL_SET_CHARSET_NAME, "utf8");

	if (!mysql_real_connect(mysql_, host, user,
		passwd, db, 0, NULL, 0))
	{
		string errmsg = mysql_error(mysql_);
		Close();
		throw Exception("DB ERROR:"+errmsg);
	}
}

void MysqlDB::Close()
{
	if (NULL != mysql_)
	{
		mysql_close(mysql_);
		mysql_ = NULL;
	}
}

MysqlRecordset MysqlDB::QuerySQL(const char* sql)
{
    //printf("要执行的sql: %s\n", sql);
	if (mysql_query(mysql_, sql) != 0)
	{
		//int errno = mysql_errno(mysql_);
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}

	MYSQL_RES*  mysql_res;
	mysql_res = mysql_store_result(mysql_);

    //得到查询返回的行数
	//unsigned long n = mysql_affected_rows(mysql_);
    
	//指向  mysql 的查询字段集
	MYSQL_FIELD* mysql_field = NULL;
	
	MysqlRecordset rs;
	unsigned int i = 0;
	unsigned int nCols = mysql_num_fields(mysql_res);
	while ((mysql_field = mysql_fetch_field(mysql_res)) != NULL)
	{
		MysqlRecordset::FIELD field;
        ///如果相等则无别名 直接将filed名返回 如果有别名 则将别名+列名拼起来
        if (strcmp(mysql_field->org_table, mysql_field->table) == 0) {
            field.name =  mysql_field->name;
        } else {
            field.name = std::string(mysql_field->table) + std::string(".") + std::string(mysql_field->name);
        }
		
		field.index = i;
		++i;
		rs.fields_.push_back(field);
	}
 
	MYSQL_ROW mysql_row;
	while ((mysql_row = mysql_fetch_row(mysql_res)))
	{
		MysqlRecordset::ROW row(nCols);
		for (unsigned int i = 0; i< nCols; ++i)
		{
			row[i] = mysql_row[i] ? mysql_row[i] : "";
		}
		rs.rows_.push_back(row);
		
	}
	

	mysql_free_result(mysql_res);

	return rs;

}

unsigned long long MysqlDB::ExecSQL(const char* sql)
{
    //printf("要执行的sql: %s\n", sql);
	if (mysql_query(mysql_, sql) != 0)
	{
		//int errno = mysql_errno(mysql_);
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}

	return mysql_affected_rows(mysql_);

}

void MysqlDB::StartTransaction()
{
	if (mysql_query(mysql_, "START TRANSACTION") != 0)
	{
		//int errno = mysql_errno(mysql_);
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}
}

void MysqlDB::Commit()
{
	if (mysql_query( mysql_, "COMMIT") != 0)
	{
		//int errno = mysql_errno(mysql_);
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}
}

void MysqlDB::Rollback()
{
	if (mysql_query(mysql_, "ROLLBACK") == 0)
	{
		//int errno = mysql_errno(mysql_);
		string errmsg = mysql_error(mysql_);
		throw Exception("DB ERROR:"+errmsg);
	}
}


unsigned long long MysqlDB::GetInsertId() const
{
	return mysql_insert_id(mysql_);
}