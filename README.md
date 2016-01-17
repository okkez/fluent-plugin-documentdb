# Azure DocumentDB output plugin for Fluentd

fluent-plugin-documentdb is a fluent plugin to output to Azure DocumentDB

## Installation

    $ gem install fluent-plugin-documentdb

## Configuration

### DocumentDB

To use Microsoft Azure DocumentDB, you must create a DocumentDB database account using either the Azure portal, Azure Resource Manager templates, or Azure command-line interface (CLI). In addition, you must have a database and a collection to which fluent-plugin-documentdb writes event-stream out. Here are instructions:

 * Create a DocumentDB database account using [the Azure portal](https://azure.microsoft.com/en-us/documentation/articles/documentdb-create-account/), or [Azure Resource Manager templates and Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/documentdb-automation-resource-manager-cli/)
 * [How to create a database for DocumentDB](https://azure.microsoft.com/en-us/documentation/articles/documentdb-create-database/)
 * [Create a DocumentDB collection](https://azure.microsoft.com/en-us/documentation/articles/documentdb-create-collection/)


### Fluentd - fluent.conf
  
    <match documentdb.*>
        type documentdb
        docdb_endpoint  DOCUMENTDB_ACCOUNT_ENDPOINT
        docdb_account_key DOCUMENTDB_ACCOUNT_KEY
        docdb_database  mydb
        docdb_collection mycollection
        time_format %s
        localtime false
        add_time_field true
        time_field_name time
        add_tag_field true
        tag_field_name time
    </match>

 * **docdb\_endpoint (required)** - Azure DocumentDB Account endpoint URI
 * **docdb\_account\_key (required)** - Azure DocumentDB Account key (master key). You must NOT set a read-only key
 * **docdb\_database (required)** - DocumentDB database nameb
 * **docdb\_collection (required)** - DocumentDB collection name
 * **auto\_create\_database** - Default:true. By default, DocumentDB database named **docdb\_database** will be automatically created if it does not exist
 * **auto\_create\_collectione** - Default:true. By default, DocumentDB database named **docdb\_collection** will be automatically created if it does not exist
 * **localtime (optional)** - Default:false. By default, time record is inserted with UTC (Coordinated Universal Time). This option allows to use local time if you set localtime true
 * **time\_format (optional)** -  Default:%s. Time format for a time field to be inserted. Default format is %s, that is unix epoch time. If you want it to be more human readable, set this %Y%m%d-%H:%M:%S, for example.
 * **add\_time\_field (optional)** - Default:true. This option allows to insert a time field to record
 * **time\_field\_name (optional)** - Default:time. Time field name to be inserted
 * **add\_tag\_field (optional)** - Default:true. This option allows to insert a tag field to record
 * **tag\_field\_name (optional)** - Default:tag. Tag field name to be inserted


## Expected Records

fluent-plugin-documentdb will add **id** attribute which is UUID format and any other attributes of record automatically. In addition, it will add **time** and **tag** attributes if **add_time_field** and **add_tag_field** are true respectively. For example if you read apache's access log via fluentd, structure of the record to inserted into documentdb will have been like this.

<u>fluent.conf</u>

    <source>
        type tail                          # input plugin
        path /var/log/apache2/access.log   # monitoring file
        pos_file /tmp/fluentd_pos_file     # position file
        format apache                      # format
        tag documentdb.access              # tag
    </source>
    
    <match documentdb.*>
        docdb_endpoint https://yoichikademo.documents.azure.com:443/
        docdb_account_key Tl1xykQxnExUisJ+BXwbbaC8NtUqYVE9kUDXCNust5aYBduhui29Xtxz3DLP88PayjtgtnARc1PW+2wlA6jCJw==
        docdb_database mydb
        docdb_collection mycollection
        localtime true
        time_format %Y%m%d-%H:%M:%S
        add_time_field true
        time_field_name time
        add_tag_field true
        tag_field_name tag
    </match>

An expected output record for sample input will be like this:

<u>Sample Input (apache access log)</u>

    125.212.152.166 - - [17/Jan/2016:05:03:25 +0000] "GET /foo/bar/test.html HTTP/1.1" 304 179 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"


<u>Output Record</u>

    {
        id :  d2b2ece8-b948-41ae-a894-0ed1266e242a,
        host :  125.211.152.166,
        user :  -,
        method :  GET,
        path :  /foo/bar/test.html,
        code :  304,
        size :  179,
        referer :  -,
        agent :  Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36,
        time :  20160117-05:03:25,
        tag :  documentdb.access
    }  

## Tests
### Running test code
    $ git clone https://github.com/yokawasa/fluent-plugin-documentdb.git
    $ cd fluent-plugin-documentdb
    
    # edit CONFIG params of test/plugin/test_documentdb.rb 
    $ vi test/plugin/test_documentdb.rb
    
    # run test 
    $ rake test

### Creating package, running and testing locally 
    $ rake build
    $ rake install:local
     
    # funning fluentd with your fluent.conf
    $ fluentd -c fluent.conf -vv &
     
    # send test apache requests for testing plugin ( only in the case that input source is apache access log )
    $ ab -n 5 -c 2 http://localhost/foo/bar/test.html

## TODOs
 * Support documentdb sharding. See [How to partition data in DocumentDB](https://azure.microsoft.com/en-us/documentation/articles/documentdb-sharding/)
 * Support resource tokens access. See [Access Control on DocumentDB Resources](https://msdn.microsoft.com/en-us/library/azure/dn783368.aspx)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yokawasa/fluent-plugin-documentdb.

## Copyright

<table>
  <tr>
    <td>Copyright</td><td>Copyright (c) 2016- Yoichi Kawasaki</td>
  </tr>
  <tr>
    <td>License</td><td>Apache License, Version 2.0</td>
  </tr>
</table>

